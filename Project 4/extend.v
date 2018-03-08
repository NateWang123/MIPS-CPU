module extend(imm, ExtOp, result);
    input [15:0] imm;
    input [1:0] ExtOp;
    output [31:0] result;

    assign result = (ExtOp==2'b00)? {16'h0000,imm}:
                    (ExtOp==2'b01)? {{16{imm[15]}},imm[15:0]}:  
                    (ExtOp==2'b10)? {imm, 16'h0000} : 0;            
endmodule

