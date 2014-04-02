// Program Counter

module PC(clock,D,reset,enable,Q,J,DataOut);
parameter ADDR_MAX=16;
input J;
input clock;
input [ADDR_MAX-1:0] D,DataOut;
input reset,enable;
output [ADDR_MAX-1:0] Q;

reg [ADDR_MAX-1:0] Qtemp;

assign Q= Qtemp;

always@(posedge clock) begin

if(reset == 1'b1)
   Qtemp<=0;
else
		if(enable == 1'b1)
		  begin
		  if(!J)
			 Qtemp<=Qtemp+1;
			else
			 Qtemp<=Qtemp+{{4{DataOut[11]}},DataOut[11:0]};
			end
		else
			Qtemp<=Qtemp;
end

endmodule

/*module next_PC(Q,J,D);
input Q,J;
output D;

always@()
begin
if(J)
  Q=
end

endmodule
*/