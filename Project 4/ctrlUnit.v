module ctrlUnit(clk, rst, IRout, zero, IntReq, RegDst, ALUSrc, RegSrc, RegWrite, MemWrite, PCWrite, IRWrite, ExtOp, ALUop, NPCop, Lb, Sb, IsE, Wen, DEVREADER, EXLSet, EXLClr);
    input clk, rst, zero, IntReq, DEVREADER;
    input [31:0] IRout;
    output [2:0] ALUop;
    output [4:0] NPCop;
    output [1:0] ExtOp;
    output [1:0] RegDst;
    output [2:0] RegSrc; 
    output ALUSrc, RegWrite, MemWrite, PCWrite, IRWrite, Lb, Sb, IsE;
    output Wen; 
    output reg EXLSet, EXLClr; 
    parameter S0=0,S1=1,S2=2,S3=3,S4=4,S5=5,S6=6,S7=7,S8=8,S9=9,S10=10,S11=11;
    reg [3:0] state;
    
    wire [5:0] op,funct;
    wire add, addu, subu, slt, addi, addiu, ori, lui, lw, sw, lb, sb, beq, j, jal, jr, eret, mfc0, mtc0;
    
    wire Intr, Eret, Jump, Branch, Jr; 
    
    assign op = IRout[31:26];
    assign funct = IRout[5:0];
  
    //R type Instruction
	 assign add  = (op == 6'b0)&(funct == 6'b100000);
    assign addu = (op == 6'b0)&(funct == 6'b100001);
    assign subu = (op == 6'b0)&(funct == 6'b100011);
    assign slt  = (op == 6'b0)&(funct == 6'b101010);
    assign jr   = (op == 6'b0)&(funct == 6'b001000);
      
    //I & J type Instructin
    assign addi  = (op == 6'b001000);
    assign addiu = (op == 6'b001001);
    assign ori   = (op == 6'b001101);
    assign lui   = (op == 6'b001111);
    assign lw    = (op == 6'b100011);
    assign sw    = (op == 6'b101011);
    assign lb    = (op == 6'b100000);
    assign sb    = (op == 6'b101000);
    assign beq   = (op == 6'b000100);
    assign j     = (op == 6'b000010);
    assign jal   = (op == 6'b000011);
    
    //CP0
    assign eret = (IRout == 32'h42000018);
    assign mfc0 = (IRout[31:21] === 11'b010000_00000)&(IRout[10:0] === 11'b0);
    assign mtc0 = (IRout[31:21] == 11'b010000_00100)&(IRout[10:0] == 11'b0);
   
    //FSM 
    always@(posedge clk or negedge rst)
    begin
      if(!rst)
        begin
          state <= S11;
          EXLSet <= 1'b0;
          EXLClr <= 1'b1;  
        end 
      else
		begin
		  if(eret)
			begin
          EXLSet <= 1'b0;
          EXLClr <= 1'b1;
			end
			
        case(state)
          S11:state<=S0;
			 S0:state<=S1;	//get Instruction
          S1:if(lw||sw||lb||sb||mfc0||mtc0) state<=S2;
             else if(add||addu||subu||slt||addi||addiu||ori||lui||jr) state<=S6;
             else if(beq) state<=S8;
             else if(j||jal||eret) state<=S9;
             else state<=S11;
          S2:if(lw||lb||mfc0) state<=S3;   
             else if(sw||sb||mtc0) state<=S5;
          S3:state<=S4; //op==Lw 
          S4:if(IntReq) state<=S10;
             else state<=S11; //Memory Writing
          S5:if(IntReq) state<=S10;
             else state<=S11; //op==Sw
          S6:state<=S7; //op==R&I type,AlU Data Source select
          S7:if(IntReq) state<=S10;
             else state<=S11; //AlU calculating
          S8:if(IntReq) state<=S10;
             else state<=S11; //op==Beq
          S9:if(IntReq) state<=S10;
             else state<=S11; //op==J&Jal
          S10:
            begin
              EXLSet <= 1'b1;
              EXLClr <= 1'b0;
              state <= S11;
            end
          default:state<=S11;
        endcase
		 end
     end
     
    
    //Control Sign Using FSM
    assign PCWrite  = (state == S0)||((beq && zero && state == S8))||(j && state == S9)||(jal && state == S9)||(jr && state == S7)||(eret && state == S9)|| state == S10;
    assign IRWrite  = (state == S0)||(state == S10);
    
    assign RegWrite = ((lw|lb|mfc0) && state == S4)||((add|addu|subu|addi|addiu|slt|ori|lui) && state == S7)||((jal) && state == S9);
    assign MemWrite = (sw|sb) && state == S5;
    assign Wen      = (mtc0 && state == S5) || state == S10;
   
    assign ALUSrc   = ((lw|sw|lb|sb|ori|lui|addi|addiu) && state == S1)||((lw|sw|lb|sb) && state == S2)||((lw|lb) && (state == S3 || state == S4))||((sw|sb) && state == S5)||((ori|lui|addi|addiu) && (state == S6 || state == S7));
    
    assign Intr     = state == S10;
    assign Eret     = (eret) && (state == S9);
    assign Jump     = (j|jal) && (state == S9);
    assign Branch   = (beq) && (state == S1||state == S8);
    assign Jr       = (jr) && (state == S1||state == S6||state ==S7);
    assign NPCop    = {Intr,Eret,Jump,Branch,Jr};
    
    assign Lb       = (lb) && (state == S1||state == S3||state == S4);
    assign Sb       = (sb) && (state == S1||state == S5);
    assign IsE      = (addi) && (state == S1||state == S6||state == S7);
    
    assign RegDst[1]= (jal) && (state == S1||state == S9);
    assign RegDst[0]= (add|addu|subu|slt) && (state == S1||state == S6||state == S7);
    
    assign RegSrc[2]= mfc0 && (state == S1||state == S2||state == S3||state == S4);
    assign RegSrc[1]= ((jal) && (state == S1||state == S9)) || (mfc0 && state == S10) || ((lw|lb) && (state == S1||state == S2||state == S3||state == S4) && DEVREADER);
    assign RegSrc[0]= ((lw|lb) && (state == S1||state == S2||state == S3||state == S4))||((sw|sb) && (state == S1||state == S2||state == S5))||(mfc0 && state == S10);

    assign ALUop[2] = (slt) && S7;
    assign ALUop[1] = (lui|ori) && (state == S1||state == S6||state == S7);
    assign ALUop[0] = ((lui|ori|subu) && (state == S1||state == S6||state == S7))||((beq) && (state == S1||state == S8));
        
    assign ExtOp[1] = (lui) && (state == S1||state == S6||state == S7);
    assign ExtOp[0] = ((lw|lb) && (state == S1||state == S2||state == S3||state == S4))||((sw|sb) && (state == S1||state == S2||state == S5))
                      ||((addi|addiu) && (state ==  S1||state == S6||state == S7));    
endmodule
