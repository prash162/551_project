module Mux8to1(MuxIn0,MuxIn1,MuxIn2,MuxIn3,MuxIn4,MuxIn5,MuxIn6,MuxIn7,select,MuxOut);

input [15:0] MuxIn0;
input [15:0] MuxIn1;
input [15:0] MuxIn2;
input [15:0] MuxIn3;
input [15:0] MuxIn4;
input [15:0] MuxIn5;
input [15:0] MuxIn6;
input [15:0] MuxIn7;
input [2:0] select;
output [15:0] MuxOut;
reg [15:0] MuxOut;

always@(select,MuxIn0,MuxIn1,MuxIn2,MuxIn3,MuxIn4,MuxIn5,MuxIn6,MuxIn7)
begin
	case(select)
	3'b000:
		MuxOut=MuxIn0;
	3'b001:
		MuxOut=MuxIn1;
	3'b010:
		MuxOut=MuxIn2;
	3'b011:
		MuxOut=MuxIn3;
	3'b100:
		MuxOut=MuxIn4;
	3'b101:
		MuxOut=MuxIn5;
	3'b110:
		MuxOut=MuxIn6;
	3'b111:
		MuxOut=MuxIn7;
	default:
		MuxOut=0;
	endcase
end

endmodule
