module NPC(NPCop, zero, CPC, EPC, NPC, IRout, resA, JalOut);
	input [4:0] NPCop; //NPCsel
	input zero;
	input [31:0] IRout;
	input [31:0] resA;
	input [31:0] CPC;
	input [31:0] EPC;
	output [31:0] NPC;
	output [31:0] JalOut;
	
	wire[31:0] temp,extImm,JrNPC;
	assign temp = CPC+32'd4;
	
	//j&jal target
	wire [25:0] target;
	assign target= IRout[25:0];
	
	//beq target
	wire [15:0] Imm16;
	assign Imm16 = IRout[15:0];
	assign extImm={{14{Imm16[15]}},Imm16[15:0], {2{1'b0}}};
	assign JrNPC = (NPCop[0])? resA : 32'b0;
	assign JalOut=CPC;
	
	assign intr = NPCop[4];
	assign eret = NPCop[3];
	assign j=NPCop[2];
	assign Branch=NPCop[1];
	assign jr=NPCop[0]; 
	    
	//Judge NPC
  assign NPC= (Branch & zero) ? CPC+extImm:
              (Branch & !zero) ? temp:
              (j) ? {temp[31:28], target , {2{1'b0}}}:
              (jr) ? JrNPC : 
              (eret) ? EPC : 
              (intr)? 32'h00004180 : temp;
endmodule 
