module SbUnit(sb,busB,Imm32,Dmout,din);
  input sb;
  input [31:0] Imm32;
  input [31:0] busB;
  input [31:0] Dmout;
  output [31:0] din;
  wire [31:0] result;
  
  wire [31:0] tmp1,tmp2,tmp3,tmp4;
  wire [1:0] judge;
    
  assign tmp1 = {Dmout[31:8],busB[7:0]};
  assign tmp2 = {Dmout[31:16],busB[7:0],Dmout[7:0]};
  assign tmp3 = {Dmout[31:24],busB[7:0],Dmout[15:0]};
  assign tmp4 = {busB[7:0],Dmout[23:0]};
  assign judge = Imm32[1:0];
  
  assign result =(judge == 2'b00)? tmp1:
                 (judge == 2'b01)? tmp2:
                 (judge == 2'b10)? tmp3:
                 (judge == 2'b11)? tmp4:0;
  assign din = (sb)?result:busB;
endmodule
                
  



