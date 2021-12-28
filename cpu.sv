module cpu(input logic clk,
           input logic rst,
           input logic [31:0] gpio_in,
           output logic [31:0] gpio_out,
           output logic [31:0] writeback_instruction,
           output logic [11:0] pc_test,
           output logic stall_test);

        //internal signals
        //////////// Fetch/Decode Slide ////////////
        logic [11:0] PC_FETCH; // new
        logic [31:0] instruction_EX;

        logic [6:0] opcode_EX, funct7_EX;
        logic [2:0] itype_EX;
        logic [18:0] gpio_in_WB;
        logic [2:0] funct3_EX;
        logic [11:0] imm12_EX;
        logic [19:0] imm20_EX;
        logic gpio_we_EX;
        logic [4:0] rs1_EX, rs2_EX, rd_EX, rd_WB;
        logic [31:0] instruction_WB;
        logic [31:0] imm20_WB;
        logic alusrc_EX;
        logic regwrite_EX;
        logic regwrite_WB;
        logic [1:0] regsel_EX, regsel_WB;
        logic [3:0] aluop_EX;
        logic [31:0] A_EX, B_EX;
        logic [31:0] R_EX, R_WB;
        logic zero_EX;
        logic [31:0] writedata_WB;
        logic [31:0] readdata1_EX, readdata2_EX;

        // Control unit module needs to have inputs read from instruction decoder wires
        // Control unit outputs need to drive register and alu inputs as well

        ////////////////////// Signals for jb lab //////////////////////
        logic [11:0] PC_EX; //12 bit
        logic stall_EX_sig; //1 bit
        logic stall_FETCH_sig; // 1 bit
        logic [1:0] pcsrc_EX; // 2 bit signal to select

        //TODO: FIGURE OUT 13 bit or 12 bit for some
        logic [12:0] branch_offset_EX; //13 bit
        logic [20:0] jal_offset_EX; // 21 bit
        logic [12:0] jalr_offset;
        logic [11:0] branch_addr_EX; // 12 bit
        logic [11:0] jal_addr_EX; //12 bit
        logic [11:0] jalr_addr_EX; // 12 bit

        logic [11:0] imm_B_sig; //signal for B type immediate
        logic [19:0] imm_J_sig; //signal for J type immediate

        // logic[12:0] mux_out; //13 bit signal for FETCH MUX output

        //////////////////// Separation between wires and components in the cpu ////////////////////


        //initializing instruction memory (RAM)
        logic [31:0] instruction_mem [4095:0];
        initial begin
                //TO TEST: to run the testbench you must have the hexcode_jb.txt readmemh() uncommented
                // TO RUN: to run the sqrt program on the board you must have the sqrt.txt readmemh() uncommented
                //$readmemh("hexcode_jb.txt", instruction_mem); //to run test jb program from slides run this code snippet
                $readmemh("sqrt.txt", instruction_mem); //to run sqrt program run this code snippet


        end

         // FETCH stage
        always_ff @(posedge clk) begin
                if (rst) begin
                        instruction_EX <= 32'b0;
                        PC_FETCH <= 12'b0;
                        //TODO: add internal signals to zero them out
                        /*opcode_EX <= 7'b0;
                        funct7_EX <= 7'b0;
                        funct3_EX <= 3'b0;
                        imm12_EX <= 12'b0;
                        imm20_EX <= 20'b0;
                        imm_B_sig <= 13'b0;
								imm_J_sig <= 20'b0;
                        stall_EX_sig <= 1'b0;
                        stall_FETCH_sig <= 1'b0;*/
                end
                else begin // need to add new stuff here
                        // new fetch mux uses pcsrc_EX to select
                        if(pcsrc_EX == 2'b00) begin //0
                                PC_FETCH <= PC_FETCH + 12'b1;
                        end
                        else if(pcsrc_EX == 2'b01) begin //1
                                PC_FETCH <= branch_addr_EX;
                        end
                        else if(pcsrc_EX == 2'b10) begin //2
                                PC_FETCH <= jal_addr_EX;
                        end
                        else if(pcsrc_EX == 2'b11) begin //3
                                PC_FETCH <= jalr_addr_EX;
                        end
                        else begin
                                PC_FETCH <= 13'b0; // TODO: FIGURE OUT IF YOU CAN DO THIS
                        end

                        if(stall_FETCH_sig) begin
                                instruction_EX <= instruction_EX;
                        end
                        else begin
                                instruction_EX <= instruction_mem[PC_FETCH];  
                        end
                        
                        instruction_WB <= instruction_EX;
                        // PC_FETCH <= PC_FETCH + 12'b1;
                end
        end

        //TODO: Combinational or Clocked
        always_comb begin
                branch_offset_EX = {imm_B_sig, 1'b0};
                branch_addr_EX = PC_EX + {branch_offset_EX[12], branch_offset_EX[12:2]}; 

                jal_offset_EX = {imm_J_sig, 1'b0};
                jal_addr_EX = PC_EX + jal_offset_EX[13:2];

                jalr_offset = instruction_EX[31:20];
                jalr_addr_EX = readdata1_EX[11:0] + jalr_offset[11:0]; //need to divide jump target by 4
        end

        // EX stage
        always_ff @(posedge clk) begin
                rd_WB <= rd_EX;

                imm20_WB <= {instruction_EX[31:12], 12'b0};

                regwrite_WB <= regwrite_EX; //async assign with write enable for regwrite_WB and regwrite_EX

                //async everything happens and sync happens in sequential
                regsel_WB <= regsel_EX;

                gpio_in_WB <= gpio_in;

                R_WB <= R_EX;

                //gpio_we select register
                if(gpio_we_EX) begin
                        gpio_out <= readdata1_EX;
                end

                PC_EX <= PC_FETCH; // new

                stall_EX_sig <= stall_FETCH_sig; // new
        end

        //multiplexer using regsel_WB as the select
        always_comb begin
                if(regsel_WB == 2'b00) begin // 0
                        writedata_WB = gpio_in_WB;
                end
                else if(regsel_WB == 2'b01) begin // 1
                        writedata_WB = imm20_WB;
                end
                else if(regsel_WB == 2'b10) begin // 2
                        writedata_WB = R_WB;
                end
                //new else if clause below
                else if(regsel_WB == 2'b11) begin // 3
                        writedata_WB = PC_EX;
                end
                else writedata_WB = 32'b0; //TODO: Figure out if you can add this clause or if you need to expand the multiplexer
        end

         //multiplexer using alusrc_EX as the select
        always_comb begin
                if(alusrc_EX == 1'b0) begin // 0
                        B_EX = readdata2_EX; //Instruction
                end
                else if(alusrc_EX == 1'b1) begin // 1
                        B_EX = {{20{instruction_EX[31]}}, instruction_EX[31:20]}; //Sign Extend
                end
                else B_EX = 32'b0;
        end

        //For testbench
        assign writeback_instruction = instruction_WB; 
        assign pc_test = PC_FETCH;
        assign stall_test = stall_FETCH_sig; 

        // instruction decoder module
        insdec id(
                .in(instruction_EX),
                .funct7(funct7_EX),
                .opcode(opcode_EX),
                .rs1(rs1_EX),
                .rs2(rs2_EX),
                .rd(rd_EX),
                .funct3(funct3_EX),
                .imm12(imm12_EX),
                .imm20(imm20_EX),
                .imm_B(imm_B_sig), //new
                .imm_J(imm_J_sig), //new
                .instruction_type(itype_EX)
                );

        // control unit module
        conuni cu(
                .funct7(funct7_EX),
                .opcode(opcode_EX),
                .rs1(rs1_EX),
                .rs2(rs2_EX),
                .rd(rd_EX),
                .funct3(funct3_EX),
                .imm12(imm12_EX),
                .imm20(imm20_EX),
                .instruction_type(itype_EX),
                .stall_EX(stall_EX_sig), // new
                .R(R_EX), //new 
                .aluop(aluop_EX),
                .alusrc(alusrc_EX),
                .regsel(regsel_EX),
                .regwrite(regwrite_EX),
                .gpio_we(gpio_we_EX),
                .stall_FETCH(stall_FETCH_sig), //new
                .pcsrc(pcsrc_EX) //new
                );

         // register file module
        regfile rf(
                .clk(clk),
                .rst(rst),
                .we(regwrite_WB),
                .readaddr1(rs1_EX),
                .readaddr2(rs2_EX),
                .writeaddr(rd_WB),
                .writedata(writedata_WB),
                .readdata1(readdata1_EX),
                .readdata2(readdata2_EX)
                );

        assign A_EX = readdata1_EX;

        // alu module
        alu logicunit(
                .A(A_EX),
                .B(B_EX),
                .op(aluop_EX),
                .R(R_EX),
                .zero(zero_EX)
                );
endmodule
                                   
