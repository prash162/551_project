module fpu(Sa,Sb,Va,Vb,Vout,V,Sout, fpu_done,VADD,VDOT,SMUL);
  input [255:0] Va,Vb;
  input VADD,VDOT,SMUL;
  output reg [255:0] Vout;
  output [15:0] Sout;
  output V;
  input [15:0] Sa,Sb;
  output reg fpu_done;
   wire [255:0] Vadd_out,Vdot_out,Smul_out;
   wire [2:0] op;

  wire V1 ; 
  wire V2 ; 
  wire V3 ; 
  wire V4 ; 
  wire V5 ; 
  wire V6 ; 
  wire V7 ; 
  wire V8 ; 
  wire V9 ; 
  wire V10; 
  wire V11; 
  wire V12; 
  wire V13; 
  wire V14; 
  wire V15; 
  wire V16; 




  assign op={VADD,VDOT,SMUL};
  assign V=(V1|V2|V3|V4|V5|V6|V7|V8|V9|V10|V11|V12|V13|V14|V15|V16);

  always@(*)
  begin
    case(op)
      3'b100:  Vout=Vadd_out;
      3'b010:  Vout=Vdot_out;
      3'b001:  Vout=Smul_out;
      default: Vout=255'b0;
    endcase
   fpu_done= 1'b1;   
  end
 
fp_adder fp1(Va[15:   0], Vb[15:   0], Vadd_out[15:   0] ,V1  );
fp_adder fp2(Va[31:  16], Vb[31:  16], Vadd_out[31:  16] ,V2  );
fp_adder fp3(Va[47:  32], Vb[47:  32], Vadd_out[47:  32] ,V3  );
fp_adder fp4(Va[63:  48], Vb[63:  48], Vadd_out[63:  48] ,V4  );
fp_adder fp5(Va[79:  64], Vb[79:  64], Vadd_out[79:  64] ,V5  );
fp_adder fp6(Va[95:  80], Vb[95:  80], Vadd_out[95:  80] ,V6  );
fp_adder fp7(Va[111: 96], Vb[111: 96], Vadd_out[111: 96] ,V7  );
fp_adder fp8(Va[127:112], Vb[127:112], Vadd_out[127:112] ,V8  );
fp_adder fp9(Va[143:128], Vb[143:128], Vadd_out[143:128] ,V9  );
fp_adder fp10(Va[159:144], Vb[159:144], Vadd_out[159:144],V10 );
fp_adder fp11(Va[175:160], Vb[175:160], Vadd_out[175:160],V11 );
fp_adder fp12(Va[191:176], Vb[191:176], Vadd_out[191:176],V12 );
fp_adder fp13(Va[207:192], Vb[207:192], Vadd_out[207:192],V13 );
fp_adder fp14(Va[223:208], Vb[223:208], Vadd_out[223:208],V14 );
fp_adder fp15(Va[239:224], Vb[239:224], Vadd_out[239:224],V15 );
fp_adder fp16(Va[255:240], Vb[255:240], Vadd_out[255:240],V16 );

endmodule
