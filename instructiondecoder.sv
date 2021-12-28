module insdec(input logic [31:0] in,
        output logic [6:0] funct7, opcode, //7 bits
        output logic [4:0] rs1, rs2, rd, // 5 bits
        output logic [2:0] funct3, // 3 bits
        output logic [11:0] imm12, // 12 bits for I type
        output logic [19:0] imm20, // 20 bits for U type
        output logic [11:0] imm_B, // 12 bits for B type
        output logic [19:0] imm_J, // 20 bits for J type
        output logic [2:0] instruction_type // indicates which type: R, I, U
        );

        always_comb begin
                imm12 = in[31:20]; // goes into control unit as csr
                imm20 = in[31:12]; // goes into control unit
                funct7 = in[31:25]; // goes into control unit
                rs2 = in[24:20]; // goes into readaddr1
                rs1 = in[19:15]; // goes into readaddr2
                funct3 = in[14:12]; // goes into control unit
                rd = in[11:7]; // rd write back goes into writeaddr
                opcode = in[6:0]; // goes into control unit
                imm_B = {in[31], in[7], in[30:25], in[11:8]}; // immediate for B type
                imm_J = {in[31], in[19:12], in[20], in[30:21]}; // immediate for J type

                if((in[6:0] == 7'b0110011) || (in[6:0] == 7'b1110011)) begin // R type
                        instruction_type = 3'b001; // 1
                end
                else if(in[6:0] == 7'b0010011) begin // I type or itype for jalr, jalr has different opcode so have to or it with its opcode
                        instruction_type = 3'b010; // 2
                end
                else if(in[6:0] == 7'b0110111) begin // U type
                        instruction_type = 3'b011; // 3
                end
                else if(in[6:0] == 7'b1100011) begin // B type
                        instruction_type = 3'b100; //4
                end
                else if(in[6:0] == 7'b1100111)begin //JALR is I type
                        instruction_type = 3'b101; //5
                end
                else if(in[6:0] == 7'b1101111) begin  // JAL is J type
                        instruction_type = 3'b110; //6
                end
                else    instruction_type = 3'b000; // random
        end
endmodule