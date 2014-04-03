// Program Counter

module Prog_Counter(clock,D,reset,enable,Q,J,V_done,DataOut);
parameter ADDR_MAX=16;
input J,V_done;
input clock;
input [ADDR_MAX-1:0] D,DataOut;
input reset,enable;
output [ADDR_MAX-1:0] Q;

reg [ADDR_MAX-1:0] Qtemp;

assign Q= Qtemp;

always@(posedge clock) begin

if(reset == 1'b1)
   Qtemp<=0;
else begin
		if(enable == 1'b1)
		  begin
					if(!V_done) begin
							  if(!J)
									 Qtemp<=Qtemp+1;
								else
									 Qtemp<=Qtemp+{{4{DataOut[11]}},DataOut[11:0]};
								
					end
					else
							Qtemp<=16'b1111_1111_1111_0000;
				end
		else
			Qtemp<=Qtemp;
end
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