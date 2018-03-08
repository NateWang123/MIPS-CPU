`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:43:45 08/08/2017
// Design Name:   testMips
// Module Name:   D:/Computer Princliple/Project 4/MIPS_System_Xilinx/TestBench.v
// Project Name:  MIPS_System_Xilinx
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: testMips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBench;

	// Inputs
	reg clk_50MHz;
	reg rst;
	reg [7:0] swtch_butt_user1;
	reg [7:0] swtch_butt_user2;
	reg [7:0] swtch_butt_user3;
	reg [7:0] swtch_butt_user4;
	
	// Outputs
	wire [3:0] ds1;
	wire [3:0] ds2;
	wire [7:0] seg1;
	wire [7:0] seg2;

	// Instantiate the Unit Under Test (UUT)
	testMips uut (
		.clk_50MHz(clk_50MHz), 
		.rst(rst), 
		.swtch_butt_user1(swtch_butt_user1), 
		.swtch_butt_user2(swtch_butt_user2), 
		.swtch_butt_user3(swtch_butt_user3), 
		.swtch_butt_user4(swtch_butt_user4), 
		.ds1(ds1), 
		.ds2(ds2), 
		.seg1(seg1), 
		.seg2(seg2)
	);

	initial begin
		// Initialize Inputs
		clk_50MHz = 0;
		rst = 1;
		swtch_butt_user1=0; 
		swtch_butt_user2=0; 
		swtch_butt_user3=0; 
		swtch_butt_user4=0; 
		// Wait 100 ns for global reset to finish
		#10000000;
        rst=1'b0;
		#100000000;
        rst=1'b1;
		  
		#5000000;
		swtch_butt_user1=8'b0000_1111; 
		swtch_butt_user2=0; 
		swtch_butt_user3=0; 
		swtch_butt_user4=0; 
		// Add stimulus here
	end
	always #100 clk_50MHz=~clk_50MHz;
      
endmodule

