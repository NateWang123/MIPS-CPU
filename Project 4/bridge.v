module bridge(pr_Addr,pr_Wd,pr_Rd,We_CPU,Intrp,Intrpout,DEV_Addr,DEV_Wd,DEV0_Rd,DEV1_Rd,DEV2_Rd,DEV3_Rd,DEV0_We,DEV1_We,DEV2_We,DEV3_We,DEVREADER);
  input [31:0] pr_Addr;
  input [31:0] pr_Wd;
  input [31:0] DEV0_Rd,DEV1_Rd,DEV2_Rd,DEV3_Rd;
  input We_CPU;
  input Intrp;
  
  output DEV0_We,DEV1_We,DEV2_We,DEV3_We,DEVREADER;
  output [31:0] pr_Rd;
  output [7:2] DEV_Addr;
  output [31:0] DEV_Wd;
  output [5:0] Intrpout;

  //Decoder
  assign HitDEV0 = (pr_Addr[31:8] == 'h0000_7D);
  assign HitDEV1 = (pr_Addr[31:8] == 'h0000_7F);
  assign HitDEV2 = (pr_Addr[31:8] == 'h0000_7E);
  assign HitDEV3 = (pr_Addr[31:8] == 'h0000_7C); 
  assign DEVREADER = (HitDEV0|HitDEV1|HitDEV2|HitDEV3);
  assign DEV_Addr = pr_Addr[7:2];
  
  //MUX
  assign DEV0_We = We_CPU&HitDEV0;
  assign DEV1_We = We_CPU&HitDEV1;
  assign DEV2_We = We_CPU&HitDEV2;
  assign DEV3_We = We_CPU&HitDEV3;
  
  assign pr_Rd = (HitDEV0) ? DEV0_Rd :          
                 (HitDEV1) ? DEV1_Rd :
                 (HitDEV2) ? DEV2_Rd :
                 (HitDEV3) ? DEV3_Rd :
                 32'b0;
  //Write
  assign DEV_Wd = (DEV0_We | DEV1_We | DEV2_We | DEV3_We) ? pr_Wd : 32'b0;
  
  //Other 
  assign 	Intrpout = {3'b0,Intrp,2'b0};
endmodule