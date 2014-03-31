module dec3to8(writeaddress,wren,decOut);

input [2:0] writeaddress;
input wren;
output [7:0] decOut;

reg [7:0] decOut;

always@(writeaddress,wren)
begin

if(wren !=1)
decOut=8'b00000000;
else
begin
	case(writeaddress)
	3'b000:
		decOut=8'b00000001;
	3'b001:
		decOut=8'b00000010;
	3'b010:
		decOut=8'b00000100;
	3'b011:
		decOut=8'b00001000;
	3'b100:
		decOut=8'b00010000;
	3'b101:
		decOut=8'b00100000;
	3'b110:
		decOut=8'b01000000;
	3'b111:
		decOut=8'b10000000;
	default:
		decOut=8'b00000000;
	endcase
end
end
endmodule