module t_Mem_Write;

wire [15:0] Addr;
wire WR;
wire [15:0] DataIn;
wire done_vst;
reg Clk1, Clk2, Rst;
reg [255:0] DataBuff;
reg [15:0] AddrIn;


reg [15:0] temp = 16'b0;


initial
begin
	Clk1 = 0;
	Clk2 = 0;
end


Mem_Write MEM_WRIRE_1 (Addr, WR, DataIn, done_vst, Clk1, Clk2, Rst, DataBuff, AddrIn);


initial
begin
	#2;
	forever
	begin
		Clk1 = 1;
		#5 Clk1 = 0;
		#15;
	end
end

initial 
begin
	#12;
	forever
	begin
		Clk2 = 1;
		#5 Clk2 = 0;
		#15;
	end
end

initial
begin
	AddrIn = 16'b0000000010000000;
end


initial 
begin
	Rst = 1;
	#13 Rst = 0;
end


initial
begin
	DataBuff = 256'h0011002200330044005500660077008800990012002300340045005600670078;
end

endmodule
