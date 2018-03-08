module PC(clk,reset,PCWrite,NPC,PC);
	input clk,reset,PCWrite;
	input[31:0] NPC;
	output reg [31:0] PC;
	
	always @(posedge clk or negedge reset)
	   if(!reset)
	     PC <= 32'h00003000;
	   else if(PCWrite)
			 PC <=NPC; 
endmodule
