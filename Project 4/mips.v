module mips(clk, rst, IntReq, EPC, CPC, PrDin, PrDout, PrAddr, CPout, Sel, Wen, MemWrite, DEVREADER, EXLSet, EXLClr);
  input clk;   // clock
  input rst;   // reset
  input IntReq;
  input DEVREADER;
  input [31:0] EPC;
  input [31:0] PrDin;
  input [31:0] CPout;
  output Wen, MemWrite, EXLSet, EXLClr;
  output [31:0] CPC;
  output [31:0] PrDout;
  output [31:0] PrAddr;
  output [4:0] Sel;
  
  wire [31:0] CPC;
  wire [31:0] NPC, EPC, JalOut;
  wire [4:0] rs,rt,rd;
  wire [15:0] Imm16;
  wire [1:0] RegDst; 
  wire [2:0] RegSrc;
  wire [1:0] ExtOp; 
  wire [2:0] ALUop; 
  wire [4:0] NPCop;
  wire Lb, Sb, zero, ALUSrc, RegWrite, MemWrite, PCWrite, IRWrite, IsE;
  wire [31:0] IRin,IRout,data,din,D,dout,Dmout,R,result;
  wire [4:0] write_addr;
  wire [11:0] addrDm;
  wire [31:0] A,B,resA,resB;
  wire [31:0] InputB,Ext32;
  
  assign rs = IRout[25:21];
  assign rt = IRout[20:16];
  assign rd = IRout[15:11];
  assign Imm16 = IRout[15:0];
  assign data = (RegSrc == 3'b100)?CPout:
                (RegSrc == 3'b011)?PrDin:
                (RegSrc == 3'b010)?JalOut:
                (RegSrc == 3'b001)?Dmout:result;
  assign write_addr = (RegDst == 2'b10)?5'h1f:
                      (RegDst == 2'b01)?rd:rt; 
  assign InputB = (ALUSrc)?Ext32:resB;
  assign addrDm = result[13:2];
  //Devices
  assign PrAddr = result;
  assign PrDout = resB;
  assign Sel = rd;
  
  PC U_PC(clk, rst, PCWrite, NPC, CPC); 
  IM_8k U_IM(clk, CPC[12:2], IRin);
  ir U_IR(clk,rst,IRWrite,IRin,IRout);
  NPC U_NPC(NPCop, zero, CPC, EPC, NPC, IRout, resA, JalOut);
  ctrlUnit U_Ctrl(clk, rst, IRout, zero, IntReq, RegDst, ALUSrc, RegSrc, RegWrite, MemWrite, PCWrite, IRWrite, ExtOp, ALUop, NPCop, Lb, Sb, IsE, Wen, DEVREADER, EXLSet, EXLClr); 
  RegFile U_RF(rs, rt, write_addr, data, RegWrite, clk, rst, A, B);
  Register RegA(clk,A,resA);
  Register RegB(clk,B,resB);
  extend U_EXT(Imm16, ExtOp, Ext32);
  ALU U_Calculater(resA,InputB,ALUop,R,zero);
  Register RegR(clk,R,result);
  SbUnit sb1(Sb,resB,result,Dmout,din);
  DM_12k U_DM(clk,MemWrite,addrDm,din,D);
  Register RegDM(clk,D,dout);
  LbUnit lb1(Lb,resB,result,dout,Dmout);
endmodule

