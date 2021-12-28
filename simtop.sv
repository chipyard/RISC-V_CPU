/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk;
	logic rst;
	logic [31:0] SW;
	logic [31:0] HEX;
	logic [31:0] WE;
	logic [11:0] PC;
	logic STALL;
	// logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;

	cpu my_cpu_dut
	(
		// //////////// CLOCK //////////
		// .CLOCK_50(clk),
		// .CLOCK2_50(),
	    //     .CLOCK3_50(),

		// //////////// LED //////////
		// .LEDG(),
		// .LEDR(),

		// //////////// KEY //////////
		// .KEY(),

		// //////////// SW //////////
		// .SW(SW),

		// //////////// SEG7 //////////
		// .HEX0(HEX0),
		// .HEX1(HEX1),
		// .HEX2(HEX2),
		// .HEX3(HEX3),
		// .HEX4(HEX4),
		// .HEX5(HEX5),
		// .HEX6(HEX6),
		// .HEX7(HEX7)

		//drive clock and reset
		.clk(clk),
		.rst(rst),
		.gpio_in(SW),
		.gpio_out(HEX),
		.writeback_instruction(WE),
		.pc_test(PC),
		.stall_test(STALL)
	);

// your code here
///////// TEST ////////
initial begin
	rst = 1; #20; rst=0; #20;
	SW = {14'b0,18'h12345}; //hard coded hex val to look at gpio_out output
	// #600;
	// rst = 1; #20; rst = 0; #20;
end

always begin
	clk = 1; #10; 
	
	///////// CPU end to end testing ////////
	// Do gpio_ouput check
	// if(WE == 32'h00000000) begin
	// 	if(HEX != 32'h0000000c) begin //addi x1
	// 		//print expected value vs actual value along with the register in question
	// 		$error("Outputs don't match: 	expected_output=0x0000000c 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h00c00093) begin
	// 	if(HEX != 32'h00000011) begin //addi x2
	// 		$error("Outputs don't match: 	expected_output=0x00000011 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h01100113) begin
	// 	if(HEX != 32'h0000001D) begin //add x3
	// 		$error("Outputs don't match: 	expected_output=0x0000001D 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h002081b3) begin
	// 	 if(HEX != 32'h00000011) begin //sub x3
	// 		$error("Outputs don't match: 	expected_output=0x00000011 	actual_output=0x%0h", HEX);
	// 	 end
	// end
	// else if(WE == 32'h401181b3) begin
	// 	if(HEX != 32'h88000000) begin //slli x3
	// 		$error("Outputs don't match: 	expected_output=0x88000000 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h01b19193) begin 
	// 	if(HEX != 32'h08000000) begin //mul x4
	// 		$error("Outputs don't match: 	expected_output=0x08000000 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h02310233) begin
	// 	if(HEX != 32'hFFFFFFF8) begin //mulh x4
	// 		$error("Outputs don't match: 	expected_output=0xFFFFFFF8 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h02311233) begin
	// 	if(HEX != 32'h00000009) begin //mulhu x5
	// 		$error("Outputs don't match: 	expected_output=0x00000009 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h023132b3) begin
	// 	if(HEX != 32'h00000001) begin //slt x6
	// 		$error("Outputs don't match: 	expected_output=0x00000001 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h00122333) begin
	// 	if(HEX != 32'h00000000) begin //sltu x6
	// 		$error("Outputs don't match: 	expected_output=0x00000000 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h00123333) begin
	// 	if(HEX != 32'h00000008) begin //and x7
	// 		$error("Outputs don't match: 	expected_output=0x00000008 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h001273b3) begin
	// 	if(HEX != 32'hFFFFFFFC) begin //or x8
	// 		$error("Outputs don't match: 	expected_output=0xFFFFFFFC 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h00126433) begin
	// 	if(HEX != 32'h0000001D) begin //xor x9
	// 		$error("Outputs don't match: 	expected_output=0x0000001D 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h0020c4b3) begin
	// 	if(HEX != 32'h88000000) begin //andi x10
	// 		$error("Outputs don't match: 	expected_output=0x88000000 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h8001f513) begin
	// 	if(HEX != 32'hFFFFF811) begin //ori x11
	// 		$error("Outputs don't match: 	expected_output=0xFFFFF811 	actual_output=0x%0h", HEX);
	// 	end
	// end

	// else if(WE == 32'h80016593) begin
	// 	if(HEX != 32'h0000001F) begin //xori x12
	// 		$error("Outputs don't match: 	expected_output=0x0000001F 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h00e14613) begin
	// 	if(HEX != 32'h00011000) begin //sll x13
	// 		$error("Outputs don't match: 	expected_output=0x00011000 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h001116b3) begin
	// 	if(HEX != 32'h00004400) begin //srl x14
	// 		$error("Outputs don't match: 	expected_output=0x00004400 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h0021d733) begin
	// 	if(HEX != 32'hFFFFC400) begin //sra x15
	// 		$error("Outputs don't match: 	expected_output=0xFFFFC400 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h4021d7b3) begin
	// 	if(HEX != 32'h00000018) begin //slli x16
	// 		$error("Outputs don't match: 	expected_output=0x00000018 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h00109813) begin
	// 	if(HEX != 32'h00000008) begin //srli x17
	// 		$error("Outputs don't match: 	expected_output=0x00000008 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h00115893) begin
	// 	if(HEX != 32'hC4000000) begin //srai x18
	// 		$error("Outputs don't match: 	expected_output=0xC4000000 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'h4011d913) begin
	// 	if(HEX != 32'hDBEEF000) begin //lui x19
	// 		$error("Outputs don't match: 	expected_output=0xDBEEF000 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'hdbeef9b7) begin
	// 	if(HEX != 32'h88000000) begin //csrrw x20
	// 		$error("Outputs don't match: 	expected_output=0x88000000 	actual_output=0x%0h", HEX);
	// 	end
	// end
	// else if(WE == 32'hf0219a73) begin
	// 	if(SW != 32'h12345) begin // cssrw X21 (SW) <= 32'h12345
	// 		$error("Outputs don't match: 	expected_output=0x12345 	actual_output=0x%0h", SW);
	// 	end
	// end
	// else begin
	// 	$display("The actual values and expeced ground truth values are the same");
	// end
	
	if(WE == 32'h0) begin
		if(STALL != 1'h0 && PC != 12'h001) begin
			$error("Outputs don't match:		expect_output: PC_FETCH=0x001 and STALL=0x0 	actual_value: PC_FETCH=0x%0h and STALL=0x%0h", PC, STALL);
		end
	end
	else if(WE == 32'hfff00213) begin
		if(STALL != 1'h0 && PC != 12'h002) begin
			$error("Outputs don't match:		expect_output: PC_FETCH=0x002 and STALL=0x0 	actual_value: PC_FETCH=0x%0h and STALL=0x%0h", PC, STALL);
		end
	end
	else if(WE == 32'h00200293) begin
		if(STALL != 1'h0 && PC != 12'h003) begin
			$error("Outputs don't match:		expect_output: PC_FETCH=0x003 and STALL=0x0 	actual_value: PC_FETCH=0x%0h and STALL=0x%0h", PC, STALL);
		end
	end
	else if(WE == 32'h00520c63) begin
		if(STALL != 1'h1 && PC != 12'h004) begin
			$error("Outputs don't match:		expect_output: PC_FETCH=0x004 and STALL=0x1 	actual_value: PC_FETCH=0x%0h and STALL=0x%0h", PC, STALL);
		end
	end
	else if(WE == 32'h00521a63) begin
		if(STALL != 1'h0 && PC != 12'h009) begin
			$error("Outputs don't match:		expect_output: PC_FETCH=0x009 and STALL=0x0 	actual_value: PC_FETCH=0x%0h and STALL=0x%0h", PC, STALL);
		end
	end
	else if(WE == 32'hff1ff) begin
		if(STALL != 1'h0 && PC != 12'h009) begin
			$error("Outputs don't match:		expect_output: PC_FETCH=0x009 and STALL=0x0 	actual_value: PC_FETCH=0x%0h and STALL=0x%0h", PC, STALL);
		end
	end
	else begin
		$display("The actual values and expected values are the same");
	end

	clk = 0; #10;
end

endmodule


