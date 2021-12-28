module conuni(input logic [6:0] funct7, opcode, //7-bit
        input logic [4:0] rs1, rs2, rd, // 5-bit
        input logic [2:0] funct3, // 3-bit
        input logic [11:0] imm12, // 12-bit
        input logic [19:0] imm20, // 20-bit
        input logic [2:0] instruction_type, // sent from decoder, 001 is R type, 010 is I type, 011 is U type, 100 is B type, 101 is J type
        input logic stall_EX, // input stall
        input logic [31:0] R, // check for branch
        output logic [3:0] aluop, // 4-bit alu opcode value from table
        output logic alusrc, // write enable for the register, if immediate = 0 and if not immediate = 1
        output logic [1:0] regsel, // always want to take the output of the alu
        output logic regwrite, // always want to write to register
        output logic gpio_we, // 1 if there is an I/O instruction and 0 if there is not an I/O instruction
        output logic stall_FETCH, // output stall
        output logic [1:0] pcsrc
        );

    always_comb begin
        if(stall_EX) begin
            stall_FETCH = 1'b0;
            aluop = 4'b0;
            regsel = 1'b0;
            regwrite = 1'b0;
            gpio_we = 1'b0;
            pcsrc = 2'b00;
            alusrc = 1'b0;
        end

        else begin 
            //default values
            stall_FETCH = 1'b0;
            alusrc = 1'b0; // equal 1 for immediate instruction and equal 0 for not immediate instructions
            regsel = 2'b10; // we always want
            regwrite = 1'b1; // we want to always write to register
            gpio_we = 1'b0; // the majority instructions are not I/O instructions
            pcsrc = 2'b00;
            
            if(instruction_type == 3'b001) begin // Instruction is R-type
                alusrc = 1'b0;
                stall_FETCH = 1'b0;
                if(funct7 == 7'b0000000 && funct3 == 3'b000 && opcode == 7'b0110011) begin // ADD instruction
                    aluop = 4'b0011; //opcode for add instruction
                end

                else if (funct7 == 7'b0100000 && funct3 == 3'b000 && opcode == 7'b0110011) begin // SUB instruction
                    aluop = 4'b0100; //opcode for sub instruction
                end

                else if (funct7 == 7'b0000001 && funct3 == 3'b000 && opcode == 7'b0110011) begin // MUL instruction
                    aluop = 4'b0101; //opcode for MUL instruction
                end

                else if(funct7 == 7'b0000001 && funct3 == 3'b001 && opcode == 7'b0110011) begin // MULH instruction
                    aluop = 4'b0110;
                end

                else if (funct7 == 7'b0000001 && funct3 == 3'b011 && opcode == 7'b0110011) begin // MULHU instruction
                    aluop = 4'b0111;
                end

                else if (funct7 == 7'b0000000 && funct3 == 3'b010 && opcode == 7'b0110011) begin // SLT instruction
                    aluop = 4'b1100;
                end

                else if(funct7 == 7'b0000000 && funct3 == 3'b011 && opcode == 7'b0110011) begin // SLTU instruction
                    aluop = 4'b1101;
                end

                else if(funct7 == 7'b0000000 && funct3 == 3'b111 && opcode == 7'b0110011) begin // AND instruction
                    aluop = 4'b0000;
                end

                else if (funct7 == 7'b0000000 && funct3 == 3'b110 && opcode == 7'b0110011) begin // OR instruction
                    aluop = 4'b0001;
                end

                else if (funct7 == 7'b0000000 && funct3 == 3'b100 && opcode == 7'b0110011) begin // XOR instruction
                    aluop = 4'b0010;
                end

                else if(funct7 == 7'b0000000 && funct3 == 3'b001 && opcode == 7'b0110011) begin // SLL instruction
                aluop =  4'b1000;
                end

                else if(funct7 == 7'b0000000 && funct3 == 3'b101 && opcode == 7'b0110011) begin // SRL instruction
                aluop = 4'b1001;
                end

                else if(funct7 == 7'b0100000 && funct3 == 3'b101 && opcode == 7'b0110011) begin // SRA instruction
                    aluop = 4'b1010;
                end

                else if(imm12 == 12'hf02 && funct3 == 3'b001 && opcode == 7'h73) begin // CSRRW HEX Output instruction
                    aluop = 4'bXXXX;
                    alusrc = 1'b0;
                    regsel = 2'bXX;
                    regwrite = 1'b0;
                    gpio_we = 1'b1;
                end

                else if (imm12 == 12'hf00 && funct3 == 3'b001 && opcode == 7'h73) begin // CSRRW SW Input Instruction
                    aluop = 4'bXXXX;
                    alusrc = 1'b0;
                    regsel = 2'b00;
                end
                else begin
                    aluop = 4'bXXXX;
                    alusrc = 1'b0;
                    regsel = 2'bXX;
                    regwrite = 1'bX;
                    gpio_we = 1'bX;
                end
            end

            else if(instruction_type == 3'b010) begin // Instruction is I-type
                alusrc = 1'b0;
                stall_FETCH = 1'b0;
                if(funct3 == 3'b000 && opcode == 7'b0010011) begin // ADDI instruction
                    aluop = 4'b0011;
                    alusrc = 1'b1;
                end

                else if (funct3 == 3'b111 && opcode == 7'b0010011) begin // ANDI instruction
                    aluop = 4'b0000;
                    alusrc = 1'b1;
                end

                else if (funct3 == 3'b110 && opcode == 7'b0010011) begin // ORI instruction
                    aluop = 4'b0001;
                    alusrc = 1'b1;
                end

                else if(funct3 == 3'b100 && opcode == 7'b0010011) begin // XORI instruction
                    aluop = 4'b0010;
                    alusrc = 1'b1;
                end

                else if(funct7 == 7'b0000000 && funct3 == 3'b001 && opcode == 7'b0010011) begin // SLLI instruction
                    aluop = 4'b1000;
                    alusrc = 1'b1;
                end

                else if(funct7 == 7'b0100000 && funct3 == 3'b101 && opcode == 7'b0010011) begin // SRAI instruction
                    aluop = 4'b1011;
                    alusrc = 1'b1;
                end

                else if(funct7 == 7'b0000000 && funct3 == 3'b101 && opcode == 7'b0010011) begin // SRLI instruction
                    aluop = 4'b1001;
                    alusrc = 1'b1;
                end
                // else if(funct3 == 3'b000 && opcode == 7'b1100111) begin //JALR instruction
                //     //aluop left alone cause it does not matter
                //     pcsrc = 2'b11;
                // end

                else begin
                    aluop = 4'bXXXX;
                    alusrc = 1'b0;
                    regsel = 2'bXX;
                    regwrite = 1'bX;
                    gpio_we = 1'bX;
                end
            end

            else if(instruction_type == 3'b011) begin // Instruction is U-type
                alusrc = 1'b0;
                stall_FETCH = 1'b0;
                if(opcode == 7'b0110111) begin // LUI instruction
                    aluop = 4'bXXXX;
                    alusrc = 1'b0;
                    regsel = 2'b01;
                end

                else begin
                    aluop = 4'bXXXX;
                    alusrc = 1'b0;
                    regsel = 2'bXX;
                    regwrite = 1'bX;
                    gpio_we = 1'bX;
                end
            end
            
            else if(instruction_type == 3'b100) begin // Instruction is B-type
                alusrc = 1'b0;
                stall_FETCH = 1'b0;
                pcsrc = 2'b0;
                regwrite = 1'b0;
                if(funct3 == 3'b000 && opcode == 7'b1100011) begin // BEQ instruction
                    aluop = 4'b0100; //slide 71 say beq is sub, so got subs aluop 
                    if(R == 32'b0) begin
                        stall_FETCH = 1'b1; 
                        pcsrc = 2'b01;
                        regwrite = 1'b1;
                    end
                end

                else if(funct3 ==3'b101 && opcode == 7'b1100011) begin //BGE instruction
                    aluop = 4'b1100;
                    if(R == 32'b0) begin
                        stall_FETCH = 1'b1;
                        pcsrc = 2'b01;
                        regwrite = 1'b1;
                    end
                end

                else if(funct3 == 3'b111 && opcode == 7'b1100011) begin //BGEU instruction
                //Same as BGE instruction but using SLTU instead
                    aluop = 4'b1110;
                    if(R == 32'b0) begin
                        stall_FETCH = 1'b1;    
                        pcsrc = 2'b01;
                        regwrite = 1'b1;
                    end
                end

                else if(funct3 == 3'b100 && opcode == 7'b1100011) begin //BLT instruction
                    aluop = 4'b1100;
                    if(R == 32'b1) begin
                        stall_FETCH = 1'b1;
                        pcsrc = 2'b01;
                        regwrite = 1'b1;
                    end
                end

                else if(funct3 == 3'b110 && opcode == 7'b1100011) begin //BLTU instruction
                    //Same as BGE but using SLTU
                    aluop = 4'b1110;
                    if(R == 32'b1) begin
                        stall_FETCH = 1'b1;
                        pcsrc = 2'b01;
                        regwrite = 1'b1;
                    end
                end

                else if(funct3 == 3'b001 && opcode == 7'b1100011) begin //BNE instruction
                    aluop = 4'b0100;
                    if(R != 32'b0) begin
                        stall_FETCH = 1'b1; 
                        pcsrc = 2'b01;
                        regwrite = 1'b1;
                    end
                end

                else begin
                    aluop = 4'bXXXX;
                    alusrc = 1'b0;
                    regsel = 2'bXX;
                    regwrite = 1'bX;
                    gpio_we = 1'bX;
                end
            end
            
            else if(instruction_type == 3'b101) begin//instruction is JALR
                regsel = 2'b11;
                regwrite = 1'b1;
                pcsrc = 2'b11;
                stall_FETCH = 1'b1;
                alusrc = 1'b0;
                aluop = 4'b0000;
            end

            else if(instruction_type == 3'b110) begin // instruction is JAL
                regsel = 2'b11;
                regwrite = 1'b1;
                pcsrc = 2'b10;
                stall_FETCH = 1'b1;
                alusrc = 1'b0;
                aluop = 4'b0000;                
            end
            
            else begin // Default case
                aluop = 4'bXXXX;
                alusrc = 1'b0;
                regsel = 2'bXX;
                regwrite = 1'bX;
                gpio_we = 1'bX;
            end
        end
    end
endmodule
