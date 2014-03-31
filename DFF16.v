
module Dff16(clock,D,reset,enable,Q);
input clock;
input [15:0] D;
input reset,enable;
output [15:0] Q;

reg [15:0] Qtemp;

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