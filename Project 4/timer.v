module timer(CLK_I,RST_I,ADD_I,WE_I,DAT_I,DAT_O,IRQ);
  input CLK_I;  
  input RST_I;  
  input [7:2] ADD_I;  
  input WE_I;  
  input [31:0]DAT_I;  
  output [31:0]DAT_O;   
  output IRQ;           
  reg [31:0] CTRL,PRESET,COUNT; 
  wire IM;
  wire [2:1]Mode;
  wire Enable;
  reg mark;
 
  assign IM = CTRL[3];
  assign Mode = CTRL[2:1];
  assign Enable = CTRL[0];
  
  assign IRQ = (IM==1 && COUNT==32'b0 && mark && Mode == 2'b00);
  assign DAT_O =  ( ADD_I[3:2]==2'b10 )?PRESET:
                  ( ADD_I[3:2]==2'b01 )?CTRL:
                  ( ADD_I[3:2]==2'b00 )?COUNT:0;
  
  always @ (posedge CLK_I or negedge RST_I)
  begin
    if(!RST_I)
      begin
        CTRL=32'b0;
        PRESET=32'b0;
        COUNT=32'b0;
        mark=1'b0;
      end
    else
      begin
           if(WE_I && ADD_I[3:2]==2'b10)
           begin
           PRESET = DAT_I;
           COUNT=PRESET;
           mark=1'b1;
           end
           else if( Enable &&  COUNT!=0 )
             COUNT=COUNT-32'b1;
			  else if( Mode==2'b00 & COUNT==32'b0 )
			    COUNT=COUNT;
           else if( Mode==2'b01 & COUNT==32'b0 )
             COUNT=PRESET;
			  
           if(WE_I && ADD_I[3:2]==2'b01)
            CTRL = DAT_I;
      end 
  end  
endmodule
