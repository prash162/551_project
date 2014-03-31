// Program Counter

module PC(clock,D,reset,enable,Q);
parameter ADDR_MAX=4;
input clock;
input [ADDR_MAX:0] D;
input reset,enable;
output [ADDR_MAX:0] Q;

reg [ADDR_MAX:0] Qtemp;

assign Q= Qtemp;

always@(posedge clock) begin

if(reset == 1'b1)
   Qtemp<=0;
else
		if(enable == 1'b1)
			Qtemp<=D;
		else
			Qtemp<=Qtemp;
end
endmodule
