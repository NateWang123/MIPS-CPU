module digital(clk,rst,DEV_Addr,DEV_We,DEV_Wd,DEV_Rd,ds1,seg1,ds2,seg2);
  input clk,rst,DEV_We;
  input [7:2] DEV_Addr;
  input [31:0] DEV_Wd;
  output [31:0] DEV_Rd;
  reg [31:0] num,judge;
  output [3:0] ds1,ds2;
  output [7:0] seg1,seg2;
  
  wire [15:0] HighOut, LowOut;
  
  assign HighOut=judge[31:16];
  assign LowOut=judge[15:0];
  
  led U_Led1(clk,rst,DEV_Addr,HighOut,ds1,seg1);
  led U_Led2(clk,rst,DEV_Addr,LowOut,ds2,seg2);
  
  assign DEV_Rd = (DEV_Addr == 6'b000_000)?num:
                  (DEV_Addr == 6'b000_001)?judge:32'b0;
            
  always@(posedge clk or negedge rst)
  begin
    if(!rst)
      begin
        num <= 32'b0;
        judge <= 32'b0;   
      end
    else 
	 begin
		if(DEV_We && DEV_Addr == 6'b000_000)
			num <= DEV_Wd;
		if(DEV_We && DEV_Addr == 6'b000_001)
			judge <= DEV_Wd;
	 end
  end
endmodule
