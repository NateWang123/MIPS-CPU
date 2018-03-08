module RegFile(read_addr1, read_addr2, write_addr, data, we, clk, reset, resA, resB);
	input[4:0] read_addr1, read_addr2, write_addr;
	input[31:0] data;
	input we, clk, reset;
	output [31:0] resA, resB;
	reg [31:0] register [31:0];
	integer i;
	
	assign resA=register[read_addr1];
	assign resB=register[read_addr2];
	
	always @(posedge clk or negedge reset)
	  if(!reset)
		   begin
		    for(i=0;i<32;i=i+1)
	         register[i] <= 32'h0;
	     end
		else if (we && write_addr != 5'h0)
				register[write_addr] <= data;

endmodule