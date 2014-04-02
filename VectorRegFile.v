
module VectorRegFile(VreadA,VreadB,clk,Vwrdata,VwrAddr,VwrEn,Va,Vb,Vdone);
input [2:0] VreadA,VreadB , VwrAddr;
input clk,VwrEn;
input [255:0] Vwrdata;
output Vdone;
output reg [255:0] Va,Vb;

reg [255:0] VectorReg [7:0];
integer i=0;
always@(posedge clk)
begin
		Va<=VectorReg[VreadA];
		Vb<=VectorReg[VreadB];
		if((VwrEn==1))
			VectorReg[VwrAddr]<= Vwrdata;			
		else
			VectorReg[VwrAddr]<=VectorReg[VwrAddr];
end
endmodule



