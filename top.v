`timescale 1 ns / 1 ns
//module cpu (clk1,clk2,rst);
module CVP14 (output [15:0] Addr, output RD, output WR, output V, output [15:0] DataOut, input Reset, input Clk1, input Clk2, input [15:0] DataIn);
  
  
  
  
  reg[15:0]Latch_DataOut;
  //reg  [15:0] Addr;
  reg next_RD,next_WR,start_calc,SwrEn,VwrEn,MR_en,MW_en,RD_top,WR_top,sst_done,reg_done,nop_done,V_done;
  reg [1:0]addr_sel;
  wire [15:0]PC,next_PC;
  wire [6:0]ctrl_path; // {fpu,ld,sst,vst,sll_slh,jmp,nop}
  wire vld_done,fpu_done,Memdone,vst_done,inst_done,RD_MR,WR_MW;
  wire [15:0] addr_out,Swrdata,Sa,Sb,Sout,sll_slh_out,MemAddr_WR,MemAddr_RD,SST_WR,DataIn_s,DataIn_v;
  wire [255:0] Vwrdata,Va,Vb,Vout,DataBuff;
  wire VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP;
  reg [3:0]state,next_state;
  wire [2:0] SreadB,SreadA,VreadA,VreadB;
  wire [2:0] SwrAddr;
  
  parameter S0  = 4'b0000;// reset
  parameter S1  = 4'b0001;// IF
  parameter S2  = 4'b0010;// Decode
  parameter S3  = 4'b0011;// 
  parameter S4  = 4'b0100;
  parameter S5  = 4'b0101;
  parameter S6  = 4'b0110;
  parameter S7  = 4'b0111;
  parameter S8  = 4'b1000;
  parameter S9  = 4'b1001;
  parameter S10 = 4'b1010;
  
  
  
  //staticram sram(MemDataOut, MemAddr, DataIn, clk1, clk2, RD, WR);
  Prog_Counter pc1(Clk2,next_PC,Reset,inst_done,PC,J,V_done,Latch_DataOut);
  decoder dec(Latch_DataOut, ctrl_path, SreadB, VreadA,VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP);
  address_calculator calc(Latch_DataOut[5:0],Sb,addr_out,start_calc);
  ScalarRegFile s_reg(SreadA,SreadB,Clk2,Swrdata,SwrAddr,SwrEn,Sa,Sb);
  VectorRegFile v_reg(VreadA,VreadB,Clk2,Vwrdata,Latch_DataOut[11:9],VwrEn,Va,Vb);
  fpu fpu1(Latch_DataOut,Sa,Sb,Va,Vb,Vout,V,Sout, fpu_done,VADD,VDOT,SMUL);
  sll_slh sll0(Latch_DataOut[7:0],Sa,SLL,SLH,sll_slh_out);
  MemoryRead Mread(MemAddr_RD, RD_MR, DataBuff, vld_done, Clk1, Clk2, MR_en,addr_out , DataIn);
  Mem_Write Memwrite(MemAddr_WR, WR_MW, DataIn_v, vst_done, Clk1, Clk2, MW_en, Va, addr_out);
  SST sst1(addr_out,Sa,Clk2,SST_WR,DataIn_s);
  
//Latch_DataOut[11:9]

  //CHANGE MEMADDR_RD_WR NAME FOR WRITE AND MAKE A SST MODULE
 // fpu(Sa,Sb,Va,Vb,Vout,Sout, fpu_done);
  assign SreadA=Latch_DataOut[11:9];
  assign VreadB=Latch_DataOut[5:3];
  assign Swrdata =  (V_done==1'b1)? PC: 
                    (VDOT) ? Sout: sll_slh_out;
               
  assign Vwrdata = (VADD|SMUL) ? Vout : DataBuff; // VADD/SMUL/VLD// check after instantiation
	assign SwrAddr = (V_done==1'b1) ?  3'b111 : Latch_DataOut[11:9];

//need to give signal for flag here.  
  assign inst_done = ((reg_done|Memdone)|nop_done)|V_done;
  assign Memdone = (vst_done|sst_done);
  
  // CHANGE THIS MUX
  //assign MemAddr=(addr_sel==0)? PC:MemAddr_RD_WR ;  // addr_sel = 0 for PC, addr_sel =1 for addr_out
  assign Addr =(addr_sel==2'b00) ? PC :
                  (addr_sel==2'b01) ? SST_WR :
                  (addr_sel==2'b10) ? MemAddr_RD: MemAddr_WR;
                  
  assign DataOut = SST ? DataIn_s : DataIn_v;
 
  assign RD=(RD_MR|RD_top);
  assign WR = (VST)? WR_MW : WR_top;
  
  always@(posedge Clk1)
  begin
    if(Reset)
      begin
        state<=S0;
      end
    else
      begin
        state<=next_state;
      end
  end
  
  
  

  
  always@(*)
  begin
    case(state)
      S0:  begin
              next_state=S1;  
           end 
      S1:  begin
              next_state=S2;  
           end 
      S2:  begin
            case(ctrl_path) // {fpu,ld,sst,vst,sll_slh,jmp,nop}
              7'b100_0000: next_state=S3; // fpu operation
              7'b010_0000: next_state=S4; // address calculation for ld 
              7'b001_0000: next_state=S4; // address calculation for scalar store
              7'b000_1000: next_state=S4; // address calculation for vector store
              7'b000_0100: next_state=S5; // sll slh
              7'b000_0010: next_state=S0; // jmp
              7'b000_0001: next_state=S10; // one cycle for nop
              default: next_state=S0;
            endcase
           end 
      S3:  begin
            if(fpu_done) next_state=S6;
            else next_state=S3; 
           end
      S4:  begin
            if(ctrl_path[5]) // vld
                next_state=S7;  
           else if (ctrl_path[4]) //sst
                next_state=S8;  
           else if (ctrl_path[3]) //vst
                next_state=S9;  
           else next_state=S4; 
           end
      S5:  begin
               next_state=S6;    
           end
      
      S6:  begin
              next_state=S0;    
           end
      S7:  begin
            if(vld_done)
              next_state=S6; 
            else   
              next_state=S7;
           end
      S8:  begin
           next_state=S0;    
           end
      S9:  begin     
            if(vst_done)
              next_state=S0; 
            else   
              next_state=S9;
            end
      S10: next_state=S0;
           
            
      default:  begin
                next_state=S0;    
                end
      
    endcase
  end // end always
  
  // Memory control assert
  always@(posedge Clk2)
  begin
    if(Reset) 
      begin
        RD_top<=1'b0;
        WR_top<=1'b0;
        end
    else
      begin
        RD_top<=next_RD;
        WR_top<=next_WR;
      end
   end
  
  //---------Latch the data out at clk2 -----
  always@(posedge Clk2)
  begin
    case(state)
      S2: Latch_DataOut<=DataIn;
      default: Latch_DataOut<=Latch_DataOut;
    endcase
  end
  
  // Memory control
    always@(state)
    begin
    next_RD=1'b0;
    next_WR=1'b0;
   
        
      case(state)  
      S1:  begin
            next_RD=1'b1;
            next_WR=1'b0;
           end
      S8:  begin
            next_RD=1'b0;
            next_WR=1'b1;
           end
      endcase 
    end // end always
  
 //---------------Enable Signals ------------------// 
    
  always@(state)
  begin
    addr_sel=2'b00;
    start_calc=1'b0;
    VwrEn=1'b0;
    SwrEn=1'b0;
    MR_en=1'b0;
    MW_en=1'b0;
    V_done=1'b0;
    
    case(state)
      S0: begin addr_sel=2'b00; end
      S4: begin start_calc=1'b1; end
        
      S6: begin
						if ((V==1'b1) && (fpu_done==1'b1))
							begin
								V_done=1'b1;
								SwrEn=1'b1;
								VwrEn=1'b1;
							end
					else
							begin
								V_done=1'b0;
		            SwrEn = (VDOT|SLH|SLL)? 1'b1: 1'b0;
		            VwrEn = (VADD|SMUL|VLD)? 1'b1: 1'b0;
							end
          end
      S7:  begin addr_sel=2'b10; MR_en=1'b1; end
      S8:  begin addr_sel=2'b01; end
      S9:  begin addr_sel=2'b11; MW_en=1'b1; end
           
      endcase
    end // end always
    
 //------------------------PC Control signals --------//
  always@(state)
  begin
    reg_done=1'b0;
    sst_done=1'b0;
    nop_done=1'b0;
    case(state)
      S6: reg_done=1'b1;
      S8: sst_done=1'b1;
      S10: nop_done=1'b1;
    endcase
  end    
  
endmodule

module address_calculator(immediate,Sb,out_addr,start_calc);
  input start_calc;
  input [15:0] Sb;
  input [5:0] immediate;
  output reg [15:0] out_addr;
  wire [15:0] offset; 
  assign offset={{10{immediate[5]}},immediate[5:0]};
  always@(*)
  begin
  if(start_calc==1)
    out_addr = offset+Sb;
  else
    out_addr=out_addr;
  end // end always
endmodule


module SST(addr_out,Sa,Clk,SST_WR,data2mem);
input [15:0] addr_out;
input [15:0] Sa;
input Clk;
output [15:0]SST_WR;
output [15:0]data2mem;
assign SST_WR=addr_out;
assign data2mem=Sa;

endmodule