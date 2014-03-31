module ScalarRegFile(SreadA,SreadB,clk,Swrdata,Swraddr,Swren,Sa,Sb,Sdone);
input [2:0] SreadA,SreadB,Swraddr;
input [15:0] Swrdata;
input clk,Swren;
output reg [15:0] Sa,Sb;
output Sdone;

reg [15:0] ScalarReg [7:0];
integer i;

always@(posedge clk)
begin
	Sa <= ScalarReg[SreadA];
	Sb <= ScalarReg[SreadB];
		if(Swren==1)
			ScalarReg[Swraddr] <= Swrdata;		
		else
			ScalarReg[Swraddr] <= ScalarReg[Swraddr];
end
endmodule
