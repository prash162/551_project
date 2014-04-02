module fp_adder(input [15:0]a, input [15:0] b, output reg [15:0]res);

reg [5:0] dif_exp;
reg agtb,s,sres, bsticky;
reg [4:0] eres;
wire [13:0] fa,fb;
reg [13:0] op1,op2,op3;
reg [14:0] fres;
reg [10:0] mres;
wire [4:0] ea,eb;
wire [9:0] ma,mb;
wire sa,sb;

integer i;


assign sa=a[15];
assign ea=a[14:10];
assign ma=a[9:0];
assign sb=b[15];
assign eb=b[14:10];
assign mb=b[9:0];

assign fa={1'b1,ma,3'b0};
assign fb={1'b1,mb,3'b0};

always@(*)
begin
	dif_exp=ea-eb;
	agtb=1'b1;
	if(dif_exp[5]==1)
		begin
		dif_exp=~dif_exp+1;
		agtb=1'b0;
		end
	else if(dif_exp==6'b0)
		begin
		if(ma<mb) agtb=1'b0;
		end

	s=sa^sb;
	op1=agtb? fa: fb;
	op3=agtb? fb: fa;
	op2=op3;
	
	bsticky=1'b0;
	for(i=0;i<dif_exp;i=i+1)
		begin
	  op2=op2>>1;
		bsticky=op2[0]|bsticky;
		end
	op2[0]=bsticky;
		
	eres=agtb? ea+1'b1 :eb+1'b1; 
	fres=s? op1-op2: op1+op2;
	sres=agtb? sa : sb;
	
	if(eres>0)
		  // TODO: check what is the maximum shift to maintain normalization. Does the sticky bit shift left too?
	  	begin
 		  if(fres[14]!=1)
				begin
				fres=fres<<1;
				eres=eres-1;
				end
			
		end
 
	if(fres[3:0]<4'b1000) mres={1'b0,fres[13:4]};
	else if(fres[3:0]>4'b1000) mres=fres[13:4]+1'b1;
	else 
		begin
		if(fres[4]==1) mres=fres[13:4]+1'b1;
		else mres=fres[13:4];
		end
// dn_res may have to be normalized again after rounding
	if(mres[10]==1)
		begin
		mres=mres>>1;
		eres=eres+1'b1;
		end


res={sres,eres[4:0],mres[9:0]};
end
endmodule

module tb_fp_adder();
reg [15:0]a;
reg [15:0]b;
wire [15:0]res;

fp_adder DUT(a, b, res);

initial
begin
$monitor("a=%b,b=%b,result=%b",a,b,res );
//a=16'b0_10110_10111_00010 ; b=16'b0_10001_00100_11110; #10;
a=16'b0_10110_10111_01100 ; b=16'b0_10001_01101_01001; #10;
//a=16'b ; b=16'b; #10;
//a=16'b ; b=16'b; #10;
//a=16'b ; b=16'b; #10;
//a=16'b ; b=16'b; #10;
//a=16'b ; b=16'b; #10;
end
endmodule