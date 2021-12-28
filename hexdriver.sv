module hexdriver (input [3:0] val, output logic [6:0] HEX);

	/* your code here */
	always @(*) begin
                case (val) //Case statement for translating inputted binary to output display
                        4'h0 : HEX = 7'b1000000; //0    1 means turn segment off, since it's in the 7th place it corresponds to segment 6 in manual (pg 36)
                        4'h1 : HEX = 7'b1111001; //1
                        4'h2 : HEX = 7'b0100100; //2
                        4'h3 : HEX = 7'b0110000; //3
                        4'h4 : HEX = 7'b0011001; //4
                        4'h5 : HEX = 7'b0010010; //5
                        4'h6 : HEX = 7'b0000010; //6
                        4'h7 : HEX = 7'b1111000; //7
                        4'h8 : HEX = 7'b0000000; //8
                        4'h9 : HEX = 7'b0011000; //9
                        4'hA : HEX = 7'b0001000; //A
                        4'hb : HEX = 7'b0000011; //b
                        4'hC : HEX = 7'b1000110; //C
                        4'hd : HEX = 7'b0100001; //d
                        4'hE : HEX = 7'b0000110; //E
                        4'hF : HEX = 7'b0001110; //F

                        default : HEX = 7'b1111111;
                endcase
        end
endmodule
