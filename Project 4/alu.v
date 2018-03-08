module ALU(busA,busB,aluCtrl,result,zero);
	input [31:0] busA,busB;
	input [2:0] aluCtrl;
	output [31:0] result;
	output zero;
	
  assign  result = (aluCtrl==3'b000)?  busA + busB:  
          (aluCtrl==3'b001)?  busA - busB:
          (aluCtrl==3'b010)?  busA & busB:
          (aluCtrl==3'b011)?  busA | busB: 
          (aluCtrl==3'b100 && ((busA < busB)||(busA[31]==1&&busB[31]==0)))? 32'h0000_0001:32'h0;
   
 	assign zero = (result == 32'h00000000)?1'b1:1'b0;
endmodule