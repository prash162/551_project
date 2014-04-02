module MemoryRead(Addr, RD, DataBuff, done_vld, Clk1, Clk2, Rst, AddrIn, DataOut);

output reg [15:0] Addr;
output reg RD;
output reg done_vld;
output reg [255:0] DataBuff;
input Clk1, Clk2, Rst;
input [15:0] DataOut;
input [15:0] AddrIn;

reg [4:0] state;
reg next_done_vld;


parameter	S_Init	=	5'b11111;
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


always @ (posedge Clk1)
begin
	if (Rst == 1)
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
		default:	begin
								state <= S_Init;
							end
		endcase
	end
end

always @ (posedge Clk2)
begin
	if (Rst == 1)
	begin
		state <= S_Init;
	end

	else
	begin
		case (state)
		S0:	begin
					RD <= 1;
				end
		S1:	begin
					DataBuff[15:0] <= DataOut;
				end
		S2:	begin
					DataBuff[31:16] <= DataOut;
				end
		S3:	begin
					DataBuff[47:32] <= DataOut;
				end
		S4:	begin
					DataBuff[63:48] <= DataOut;
				end
		S5:	begin
					DataBuff[79:64] <= DataOut;
				end
		S6:	begin
					DataBuff[95:80] <= DataOut;
				end
		S7:	begin
					DataBuff[111:96] <= DataOut;
				end
		S8:	begin
					DataBuff[127:112] <= DataOut;
				end
		S9:	begin
					DataBuff[143:128] <= DataOut;
				end
		S10:	begin
						DataBuff[159:144] <= DataOut;
					end
		S11:	begin
						DataBuff[175:160] <= DataOut;
					end
		S12:	begin
						DataBuff[191:176] <= DataOut;
					end
		S13:	begin
						DataBuff[207:192] <= DataOut;
					end
		S14:	begin
						DataBuff[223:208] <= DataOut;
					end
		S15:	begin
						DataBuff[239:224] <= DataOut;
					end
		S16:	begin
						DataBuff[255:240] <= DataOut;
						RD <= 0;
					end
		default:	begin
								RD <= 0;
							end
		endcase
	end
end


always @ (state)
begin
	if (state == S16)
	begin
		next_done_vld = 1'b1;
	end
	else
	begin
		next_done_vld = 1'b0;
	end
end


always @ (posedge Clk2)
begin
	done_vld <= next_done_vld;
end

endmodule

									
		