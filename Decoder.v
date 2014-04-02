
module decoder(Instr, ctrl_path, SreadB, VreadA );
input [3:0] Instr; 
wire VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP;
wire fpu, ld_st, sll_slh;
output [6:0]ctrl_path;
reg VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP;
output [2:0] SreadB, VreadA;

always@(Instr)
begin
	case(Instr)	
		4'b0000:
			{VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP} = 10'b1000000000;
		4'b0001:
			{VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP} = 10'b0100000000;
		4'b0010:
			{VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP} = 10'b0010000000;
		4'b0011:
			{VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP} = 10'b0001000000;
		4'b0100:
			{VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP} = 10'b0000100000;
		4'b0101:
			{VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP} = 10'b0000010000;
		4'b0110:
			{VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP} = 10'b0000001000;
		4'b0111:
			{VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP} = 10'b0000000100;
		4'b1000:
			{VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP} = 10'b0000000010;
		4'b1111:
			{VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP} = 10'b0000000001;
		default:
			{VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP} = 10'b0000000000;

	endcase
	
end
assign fpu=VADD|VDOT|SMUL;
assign ld=VLD;
assign sst=SST;
assign vst=VST;
assign sll_slh=SLL|SLH;
assign nop=NOP;
assign jmp=J;
assign ctrl_path={fpu,ld,sst,vst,sll_slh,jmp,nop};

assign SreadB=(VLD|VST|SST)? Instr[8:6] : Instr[5:3];
assign VreadA=(VADD|VDOT|SMUL)? Instr[8:6] : Instr[11:9];

             

endmodule
