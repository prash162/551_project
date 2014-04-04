module fp_adder(input [15:0]a, input [15:0] b, output reg [15:0]res,output reg V);

reg [5:0] dif_exp;
reg agtb,s,sres, bsticky;
reg [5:0] eres;
wire [13:0] fa,fb;
reg [13:0] op1,op2;
reg [14:0] fres;
reg [10:0] mres;
wire [4:0] ea,eb;
wire [9:0] ma,mb;
wire sa,sb, leadBitA, leadBitB;

integer i;

assign sa=a[15];
assign ea=a[14:10];
assign ma=a[9:0];
assign sb=b[15];
assign eb=b[14:10];
assign mb=b[9:0];

assign leadBitA = ((ea==0)? 0 : 1);
assign leadBitB = ((eb==0)? 0 : 1);

assign fa={leadBitA,ma,3'b0};
assign fb={leadBitB,mb,3'b0};


always@(*)
begin
  
	dif_exp=ea-eb;
	agtb=1'b1;
	if(dif_exp[5]==1)
		begin
		dif_exp=~dif_exp+1;  // If diff is negative, then take 2's complement to get the magnitude of the number.
		agtb=1'b0;
		end
	else if(dif_exp==6'b0)
		begin
	    if(ma<mb) agtb=1'b0;
		  else agtb = agtb;  
		end

	s=sa^sb;
	op1=agtb? fa: fb;
	op2=agtb? fb: fa;
	
	if(dif_exp<14)
	begin
	 bsticky=1'b0;
	 for(i=0;i<dif_exp;i=i+1)
	   	begin
	     op2=op2>>1;
	  	  bsticky=op2[0]|bsticky;
		  end
	 op2[0]=bsticky;
	end
	else
	   op2=0;
		
	eres=agtb? ea+1'b1 :eb+1'b1; // Interpreting 1.mantissa * e^a as 0.1mantissa * e^a+1 
	fres=s? op1-op2: op1+op2;
	sres=agtb? sa : sb;
	
	repeat(14) // Is there a more efficient way?
	begin
	 if(eres>0)
		  // TODO: check what is the maximum shift to maintain normalization. Does the sticky bit shift left too? = 14
    begin
 		  if(fres[14]!=1)    //fres[14] as opposed to fres[13] since we are taking as 0.1mantissa * e^a+1.
				begin
				  fres=fres<<1;
				  eres=eres-1; 
				end		
		 end
	end
	
	if(ea==0 && eb==0 && eres==0)
	  eres=eres+1;
  
  
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
		
  if(eres<6'b011111) begin
    res={sres,eres[4:0],mres[9:0]};
    V=1'b0;
  end
  else begin
    res={sres,{5{1'b1}},{10{1'b0}}};
    V=1'b1;
  end
end // always
endmodule

module tb_fp_adder();
reg [15:0]a;
reg [15:0]b;
wire [15:0]res;
wire V;

fp_adder DUT(a, b, res, V);

initial
begin
$monitor("a=%b,b=%b,result=%b,V=%b",a,b,res,V );
//a=16'b0_10110_10111_00010 ; b=16'b0_10001_00100_11110; #10; // N and N, result N,0_10110_11000_00111
//a=16'b0_10110_10111_01100 ; b=16'b1_10001_01101_01001; #10; // N and N, result N, different signs, 0_10110_10101_11111 
//a=16'b0_10110_10111_01100 ; b=16'b0_00001_01101_01001; #10; // N and N, result N, different exponent signs, expecting a
//a=16'b1_11110_10101_00000 ; b=16'b1_11110_11111_11111; #10; // N and N, result is -infinity
//a=16'b0_11110_11111_00000 ; b=16'b0_00000_00000_11000; #10; // N and D, result should be a
//a=16'b0_00001_11111_00000 ; b=16'b0_00000_11111_11000; #10; // N and D, result will be N //
//a=16'b0_11110_10101_00000 ; b=16'b0_11110_11111_11111; #10; // N and N, result +infinity
a=16'b1_00000_11111_11111 ; b=16'b1_00000_11111_00000; #10; // D and D, result N, 1_00001_11110_11111  
//a=16'b0_00000_10101_00000 ; b=16'b1_00000_00000_00011; #10; // D and D, result D,0_00000_10100_11101
//a=16'b0_00000_00000_00000 ; b=16'b1_00000_00000_00000; #10; // +0 nad -0, result 0
//a=16'b1_00010_10101_00000 ; b=16'b1_11010_11111_11111; #10; // N and N, result N, expecting b
//a=16'b1_00010_10101_00000 ; b=16'b1_00100_11111_11111; #10; // N and N, result N, 1_00101_00010_10000 //
//a=16'b1_11111_10101_00000 ; b=16'b1_11110_11111_11111; #10; // infinity and N, result infinity
//a=16'b1_11001_10101_00000 ; b=16'b1_11110_11111_11111; #10; // N and N, result N,


end
endmodule

