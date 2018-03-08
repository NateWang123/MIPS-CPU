module CP0(clk,rst,PC,CPIn,HWInt,Sel,Wen,EXLSet,EXLClr,IntReq,EPC,CPOut);
  input clk,rst,Wen,EXLSet,EXLClr;
  input [31:0] PC;
  input [31:0] CPIn;
  input [7:2] HWInt;
  input [4:0] Sel;
  output IntReq;
  output reg [31:0] EPC;
  output [31:0] CPOut;
  integer i;    
  reg [15:10] im;
  reg exl, ie;
  reg [15:10] HWint_lock;
  reg [31:0] CP0Reg [31:0];
  
  assign CPOut = (Sel==5'd12)?{16'b0,CP0Reg[12][15:10],8'b0,CP0Reg[12][1:0]}:
                 (Sel==5'd13)?{16'b0,CP0Reg[13][15:10],10'b0}:
                 (Sel==5'd14)?CP0Reg[14]:
                 (Sel==5'd15)?CP0Reg[15]:32'b0;
  assign IntReq = (|(CP0Reg[13][15:10] & CP0Reg[12][15:10]) & !CP0Reg[12][1] & CP0Reg[12][0]);
   
  //Other
  always@(posedge clk or negedge rst)
  begin
    if(!rst)
      begin
        im <= 6'b0;
        exl <= 1'b0;
        ie <= 1'b1;
        HWint_lock <= 6'b0;
        EPC <= 32'b0;
		  for(i=0;i<32;i=i+1)
			CP0Reg[i] <= 32'b0;
      end
	 else
		begin
			//Status $CP12
			CP0Reg[12] <= {16'b0,im,8'b0,exl,ie};
			if(EXLSet && !EXLClr) 
				exl <= 1'b1;
			else if(!EXLSet && EXLClr) 
				exl <= 1'b0;
			//CAUSE $CP13
			HWint_lock <= HWInt;
			CP0Reg[13] <= {16'b0, HWint_lock, 10'b0};
			//EPC $CP14
			EPC <= CP0Reg[14];
			//PRid,$CP15
			CP0Reg[15] <= 32'h004f5da2; 
			
			//Write CP0Reg
			if(Wen)
				begin
				if(IntReq)
					CP0Reg[14] <= PC;
				if(Sel==5'd12)
					{im, exl, ie} <= {CPIn[15:10], CPIn[1], CPIn[0]};
				else if(Sel!=5'd13 && Sel!=5'd15)
					CP0Reg[Sel] <= CPIn;
				end
		end
	end
endmodule