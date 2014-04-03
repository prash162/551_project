module Mem_Write (Addr, WR, DataIn, done_vst, Clk1, Clk2, MW_en, VectorReg, AddrIn);

output reg [15:0] Addr;
output reg WR;
output reg [15:0] DataIn;
output reg done_vst;
input Clk1, Clk2, MW_en;
input [255:0] VectorReg;
input [15:0] AddrIn;

reg [4:0] state;
//reg next_done_vst;


parameter S0	=	5'b00000;
parameter S1	=	5'b00001;
parameter S2	=	5'b00010;
parameter S3	=	5'b00011;
parameter S4	=	5'b00100;
parameter S5	=	5'b00101;
parameter S6	=	5'b00110;
parameter S7	=	5'b00111;
parameter S8	=	5'b01000;
parameter S9	=	5'b01001;
parameter S10	=	5'b01010;
parameter S11	=	5'b01011;
parameter S12	=	5'b01100;
parameter S13	=	5'b01101;
parameter S14	=	5'b01110;
parameter S15	=	5'b01111;
parameter S16	=	5'b10000;
parameter	S_Init	=	5'b11111;


always @ (posedge Clk1)
begin
	if (MW_en != 1)
	begin
		state <= S_Init;
	end
	else
	begin
		case (state)
			S_Init:	begin
								state <= S0;
								Addr <= AddrIn;
							end
			S0:	begin
						state <= S1;
						Addr <= AddrIn + 1;
					end
			S1:	begin
						state <= S2;
						Addr <= AddrIn + 2;
					end
			S2:	begin
						state <= S3;
						Addr <= AddrIn + 3;
					end
			S3:	begin
						state <= S4;
						Addr <= AddrIn + 4;
					end
			S4:	begin
						state <= S5;
						Addr <= AddrIn + 5;
					end
			S5:	begin
						state <= S6;
						Addr <= AddrIn + 6;
					end
			S6:	begin
						state <= S7;
						Addr <= AddrIn + 7;
					end
			S7:	begin
						state <= S8;
						Addr <= AddrIn + 8;
					end
			S8:	begin
						state <= S9;
						Addr <= AddrIn + 9;
					end
			S9:	begin
						state <= S10;
						Addr <= AddrIn + 10;
					end
			S10:	begin
							state <= S11;
							Addr <= AddrIn + 11;
						end
			S11:	begin
							state <= S12;
							Addr <= AddrIn + 12;
						end
			S12:	begin
							state <= S13;
							Addr <= AddrIn + 13;
						end
			S13:	begin
							state <= S14;
							Addr <= AddrIn + 14;
						end
			S14:	begin
							state <= S15;
							Addr <= AddrIn + 15;
						end
			S15:	begin
							state <= S16;
							Addr <= AddrIn + 16;
						end
			S16:	begin
							state <= S_Init;
						end
		endcase
	end
end

always @ (posedge Clk2)
begin
	if (MW_en != 1)
	begin
		state <= S_Init;
	end
	else
	begin
		case (state)
			S0:	begin
						WR <= 1;
						DataIn <= VectorReg[15:0];
					end
			S1:	begin
						DataIn <= VectorReg[31:16];
					end
			S2:	begin
						DataIn <= VectorReg[47:32];
					end
			S3:	begin
						DataIn <= VectorReg[63:48];
					end
			S4:	begin
						DataIn <= VectorReg[79:64];
					end
			S5:	begin
						DataIn <= VectorReg[95:80];
					end
			S6:	begin
						DataIn <= VectorReg[111:96];
					end
			S7:	begin
						DataIn <= VectorReg[127:112];
					end
			S8:	begin
						DataIn <= VectorReg[143:128];
					end
			S9:	begin
						DataIn <= VectorReg[159:144];
					end
			S10:	begin
							DataIn <= VectorReg[175:160];
						end
			S11:	begin
							DataIn <= VectorReg[191:176];
						end
			S12:	begin
							DataIn <= VectorReg[207:192];
						end
			S13:	begin
							DataIn <= VectorReg[223:208];
						end
			S14:	begin
							DataIn <= VectorReg[239:224];
						end
			S15:	begin
							DataIn <= VectorReg[255:240];
						end
			S16:	begin
							DataIn <= 16'h0000;
							WR <= 0;
						end
			default:	begin
									DataIn <= 16'h0000;
								end
		endcase
	end
end


always @ (state)
begin
	if (state == S16)
	begin
		done_vst = 1'b1;
	end
	else
	begin
		done_vst = 1'b0;
	end
end


endmodule

