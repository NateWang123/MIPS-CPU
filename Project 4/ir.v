module ir(clk,rst,IRWrite,IRin,IRout);
    input clk,rst,IRWrite;
    input [31:0] IRin;
    output [31:0] IRout;
    reg [31:0] IRReg;
    
    assign IRout = IRReg; 
    always@(posedge clk or negedge rst)
    begin
      if(!rst)
        IRReg <= 0;
      else
        IRReg <= IRWrite?IRin:IRReg;
    end
endmodule
    
