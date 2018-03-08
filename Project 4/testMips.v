module testMips(clk_50MHz,rst,swtch_butt_user1,swtch_butt_user2,swtch_butt_user3,swtch_butt_user4,ds1,ds2,seg1,seg2);
  input clk_50MHz,rst;
  input [7:0] swtch_butt_user1,swtch_butt_user2,swtch_butt_user3,swtch_butt_user4;
  output [3:0] ds1,ds2;
  output [7:0] seg1,seg2;
  wire clk_1kHz;
  
  mini_machine U_machine(clk_1MHz,clk_1kHz,clk_500Hz,rst,swtch_butt_user1,swtch_butt_user2,swtch_butt_user3,swtch_butt_user4,ds1,seg1,ds2,seg2);
  Frequency U_Frequency(clk_50MHz,rst,clk_1MHz,clk_1kHz,clk_500Hz);
endmodule