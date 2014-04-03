module sll_slh(offset,SreadA,SLL,SLH,sll_slh_out);
  input [7:0] offset;
  input [15:0] SreadA;
  input SLL,SLH;
  output [15:0]sll_slh_out;
  wire [15:0]sll_out,slh_out;
  
  assign  sll_out = SLL ? {SreadA[15:8],offset} : SreadA;
  assign  slh_out = SLH ? {offset,SreadA[7:0]} : SreadA;
  assign  sll_slh_out= SLL ? sll_out : slh_out;
endmodule
