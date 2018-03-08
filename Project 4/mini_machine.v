module mini_machine(clk_1MHz, clk_1kHz, clk_500Hz, rst, swtch_butt_user1, swtch_butt_user2, swtch_butt_user3, swtch_butt_user4,ds1,seg1,ds2,seg2);
  input clk_1MHz,clk_1kHz,clk_500Hz,rst;
  input [7:0] swtch_butt_user1,swtch_butt_user2,swtch_butt_user3,swtch_butt_user4;
  output [3:0] ds1,ds2;
  output [7:0] seg1,seg2;
  wire Intrp,Wen,EXLsel,EXLclr,IntReq,MemWrite;
  wire [31:0] CPC,EPC,Din,CPout;
  wire [31:0] PrAddr,PrDin,PrDout;
  wire [5:0] HWInt;
  wire [4:0] Sel;
  
  wire [7:2] DEV_Addr;
  wire [31:0] DEV_Wd,DEV0_Rd,DEV1_Rd,DEV2_Rd,DEV3_Rd;
  wire        DEVREADER,DEV0_We,DEV1_We,DEV2_We,DEV3_We;
  wire [3:0]  ds1,ds2;
  wire [7:0]  seg1,seg2;
  wire [31:0] KeyIn = {swtch_butt_user1,swtch_butt_user2,swtch_butt_user3,swtch_butt_user4};
 
  mips U_Mips(clk_1kHz, rst, IntReq, EPC, CPC, PrDin, PrDout, PrAddr, CPout, Sel, Wen, MemWrite, DEVREADER, EXLSet, EXLClr);
  CP0 U_CP0(clk_1kHz, rst, CPC, PrDout, HWInt, Sel, Wen, EXLSet, EXLClr, IntReq, EPC, CPout);
  bridge U_Bridge(PrAddr, PrDout, PrDin, MemWrite, Intrp, HWInt, DEV_Addr, DEV_Wd, DEV0_Rd, DEV1_Rd, DEV2_Rd, DEV3_Rd, DEV0_We, DEV1_We, DEV2_We, DEV3_We, DEVREADER);
  Keyboard U_Keyboard(clk_1kHz,rst,DEV_Addr,DEV0_We,DEV_Wd,DEV0_Rd,KeyIn);
  timer U_Timer		(clk_1kHz,rst,DEV_Addr,DEV1_We,DEV_Wd,DEV1_Rd,Intrp);
  digital U_Digital  (clk_1kHz,rst,DEV_Addr,DEV2_We,DEV_Wd,DEV2_Rd,ds1,seg1,ds2,seg2);
endmodule