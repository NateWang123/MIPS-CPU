module led(clk,rst,DEV_Add,Input,ds,seg);
	input clk,rst;
   input [7:2] DEV_Add;
   input [15:0] Input;
	output [3:0] ds;
	reg [3:0] ds;
	output reg [7:0] seg;
	
	reg [1:0] count;
	reg [3:0] num;
   wire [3:0] num0,num1,num2,num3;
  
   assign num3 = Input[15:12];
   assign num2 = Input[11:8];
   assign num1 = Input[7:4];
   assign num0 = Input[3:0];
	
	always @ (posedge clk or negedge rst)
	begin
	if(!rst)
		begin 
			ds = 4'b0001;
			num = num0;
		end
	else
	begin
		case(ds)
			4'b0001:begin ds=4'b0010;num=num0;end 
			4'b0010:begin ds=4'b0100;num=num1;end
			4'b0100:begin ds=4'b1000;num=num2;end
			4'b1000:begin ds=4'b0001;num=num3;end
		endcase
		
		case(num)
			4'b0000:seg=8'b11111100;
			4'b0001:seg=8'b01100000;
			4'b0010:seg=8'b11011010;
			4'b0011:seg=8'b11110010;
			4'b0100:seg=8'b01100110;
			4'b0101:seg=8'b10110110;
			4'b0110:seg=8'b10111110;
			4'b0111:seg=8'b11100000;
			4'b1000:seg=8'b11111110;
			4'b1001:seg=8'b11110110;
			4'b1010:seg=8'b11101110;
			4'b1011:seg=8'b00111110;
			4'b1100:seg=8'b10011100;
			4'b1101:seg=8'b01111010;
			4'b1110:seg=8'b10011110;
			4'b1111:seg=8'b10001110;
			default:seg=8'bz;
		endcase
	end
	end
endmodule

