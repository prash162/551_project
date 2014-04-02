module fpu(Sa,Sb,Va,Vb,Vout,Sout, fpu_done,VADD,VDOT,SMUL);
  input [255:0] Va,Vb;
  input VADD,VDOT,SMUL;
  output reg [255:0] Vout;
  output [15:0] Sout;
  input [15:0] Sa,Sb;
  output fpu_done;
   wire [255:0] Vadd_out,Vdot_out,Smul_out;
   wire op;
   assign op={VADD,VDOT,SMUL};
  
  always@(*)
  begin
    case(op)
      3'b100:  Vout=Vadd_out;
      3'b010:  Vout=Vdot_out;
      3'b001:  Vout=Smul_out;
      default: Vout=255'b0;
    endcase
      
  end
  
  fp_adder fp1(Va, Vb, Vadd_out);
endmodule