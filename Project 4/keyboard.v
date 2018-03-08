module Keyboard(clk,reset,addr,WE,DIN,DOUT,key);
  input clk,reset,WE;
  input [7:2]addr;
  input [31:0]DIN,key;
  output [31:0]DOUT;
  
  assign DOUT=key;
endmodule
