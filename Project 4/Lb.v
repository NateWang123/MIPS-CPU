module LbUnit(lb,busB,Imm32,dout,Dmout);
  input lb;
  input [31:0] Imm32;
  input [31:0] busB;
  input [31:0] dout;
  output [31:0] Dmout;
  wire [31:0] result;
  
  wire [31:0] tmp1,tmp2,tmp3,tmp4;
  wire [1:0] judge;
  assign tmp1 = {busB[31:24],dout[7:0]};
  assign tmp2 = {busB[31:24],dout[15:8]};
  assign tmp3 = {busB[31:24],dout[23:16]};
  assign tmp4 = {busB[31:24],dout[31:24]};
  assign judge = Imm32[1:0];
  
  assign result =(judge == 2'b00)? tmp1:
                 (judge == 2'b01)? tmp2:
                 (judge == 2'b10)? tmp3:
                 (judge == 2'b11)? tmp4:0;
  assign Dmout = (lb)?result:dout;
endmodule
                
  




