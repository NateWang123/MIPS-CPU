module Overflow(IsE,a,b,over);
  input IsE;
  input [31:0]a,b;
  output over;
  wire [31:0] num;
  
  assign num = a+b;
  
  assign over =(!IsE)?1'b0:
(IsE && !( ( num[31]==1 && a[31]==0 && b[31]==0 ) ||( num[31]==0 &&a[31]==1&&b[31]==1  ) ) )?1'b0:
(IsE && ( ( num[31]==1 && a[31]==0 && b[31]==0 ) ||( num[31]==0 &&a[31]==1&&b[31]==1  ) ) )?1'b1:1'b0;

endmodule
