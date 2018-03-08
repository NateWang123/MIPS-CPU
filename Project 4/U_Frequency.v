module Frequency(clk_50MHz,rst,clk_1MHz,clk_1kHz,clk_500Hz);
	input clk_50MHz,rst;
	output clk_1MHz,clk_1kHz,clk_500Hz;
	reg clk_1MHz,clk_1kHz,clk_500Hz;
	reg [31:0] count0,count1,count2;
	parameter n0=50,n1=50000,n2=100000;
	
	always@(posedge clk_50MHz)
	begin
	if(!rst)
		begin
		count0<=1'b0;
		count1<=1'b0;
		count2<=1'b0;
		
		clk_1MHz<=1'b0;
		clk_1kHz<=1'b0;
		clk_500Hz<=1'b0;
		end
	else			
		if(count0<(n0/2)-1)
			count0<=count0+1'b1;
		else
			begin
			count0<=1'b0;
			clk_1MHz<=~clk_1MHz;
			end
			
		if(count1<(n1/2)-1)
			count1<=count1+1'b1;
		else
			begin
			count1<=1'b0;
			clk_1kHz<=~clk_1kHz;
			end
			
		if(count2<(n2/2)-1)
			count2<=count2+1'b1;
		else
			begin
			count2<=1'b0;
			clk_500Hz<=~clk_500Hz;
			end
	end
endmodule
	



	
	

