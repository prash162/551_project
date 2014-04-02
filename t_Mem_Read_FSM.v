module t_MemoryRead;

wire [15:0] Addr;
wire RD;
wire done_vld;
wire [255:0] DataBuff;
reg Clk1, Clk2, Rst;
reg [15:0] DataOut;
reg [15:0] AddrIn;


reg [15:0] temp = 16'b0;


initial
begin
	Clk1 = 0;
	Clk2 = 0;
end


MemoryRead MEM_READ1 (Addr, RD, DataBuff, done_vld, Clk1, Clk2, Rst, AddrIn, DataOut);

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


always @ (posedge Clk1)
begin
	DataOut <= temp + 15;
	temp <= temp + 1;
end

endmodule
