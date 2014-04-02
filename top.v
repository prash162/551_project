module cpu (clk1,clk2,rst);
  input clk1,clk2,rst;
  
  
  wire [15:0]DataOut,DataIn;
  reg  Addr;
  reg RD, WR,next_RD,next_WR,addr_sel,start_calc,SwrEn,VwrEn;
  reg [15:0]PC,next_PC;
  wire [6:0]ctrl_path; // {fpu,ld,sst,vst,sll_slh,jmp,nop}
  wire vld_done,Sdone,Vdone,fpu_done,Memdone,vst_done,inst_done;
  wire [15:0] MemAddr,addr_out,SreadB,Swrdata,Vwrdata,Sa,Sb,Sout,sll_slh_out;
  wire [255:0] VreadA,Va,Vb,Vout,DataBuff;
  wire VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP;
  reg [3:0]state,next_state;
  
  
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
  
  
  
  staticram sram(DataOut, MemAddr, DataIn, clk1, clk2, RD, WR);
  PC pc(clk2,next_PC,rst,inst_done,PC,J,DataOut);
  //decoder dec(DataOut[15:12],ctrl_path, SreadB, VreadA);
  decoder dec(DataOut[15:12], ctrl_path, SreadB, VreadA,VADD,VDOT,SMUL,SST,VLD,VST,SLL,SLH,J,NOP);
  address_calculator calc(DataOut,addr_out,start_calc);
  ScalarRegFile s_reg(DataOut[11:9],SreadB,clk2,Swrdata,DataOut[11:9],SwrEn,Sa,Sb,Sdone);
  VectorRegFile v_reg(VreadA,DataOut[5:3],clk2,Vwrdata,DataOut[11:9],VwrEn,Va,Vb,Vdone);
  fpu fpu1(Sa,Sb,Va,Vb,Vout,Sout, fpu_done);
  sll_slh sll0(DataOut[7:0],DataOut[11:9],sll_slh_out);
  
  assign Swrdata =  (VDOT) ? Sout: sll_slh_out;
                    
  assign Vwrdata = (VADD|SMUL) ? Vout : DataBuff; // VADD/SMUL/VLD// check after instantiation
  
  assign inst_done = (Sdone|Vdone|Memdone);
  
  
  assign DataOut=(addr_sel==0)? PC: addr_out;  // addr_sel = 0 for PC, addr_sel =1 for addr_out
 
  
  always@(posedge clk1)
  begin
    if(rst)
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
              7'b000_0001: next_state=S0; // one cycle for nop
              default: next_state=S0;
            endcase
           end 
      S3:  begin
            if(fpu_done) next_state=S6;
            else next_state=S3; 
           end
      S5:  begin
               next_state=S6;    
           end
      S4:  begin
            if(ctrl_path[5]) // vld
                next_state=S7; 
           else if (ctrl_path[4]) //sst
                next_state=S8;  
           else if (ctrl_path[3]) //vst
                next_state=S10;  
           else next_state=S4; 
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
      S10:  begin     // no S9
            if(vst_done)
              next_state=S0; 
            else   
              next_state=S10;
            end
            
      default:  begin
                next_state=S0;    
                end
      
    endcase
  end // end always
  
  // Memory control assert
  always@(posedge clk2)
  begin
    if(rst)
      begin
        RD<=1'b0;
        WR<=1'b0;
      end
    else
      begin
        RD<=next_RD;
        WR<=next_WR;
        
      end
  end
  
  // Memory control
    always@(state)
    begin
    next_RD=1'b0;
    next_WR=1'b0;
        
      case(state)
        
        
      S0:  begin
            next_RD=1'b0;
            next_WR=1'b0;
           end
      S1:  begin
            next_RD=1'b1;
            next_WR=1'b0;
           end
      S8:  begin
            next_RD=1'b0;
            next_WR=1'b1;
           end
      S7:  begin
            next_RD=1'b1;
            next_WR=1'b0;
           end
      S10:  begin
            next_RD=1'b0;
            next_WR=1'b1;
           end
      
    endcase 
    end // end always
    
  always@(state)
  begin
    addr_sel=1'b0;
    start_calc=1'b0;
    VwrEn=1'b0;
    SwrEn=1'b0;
    
    
    case(state)
      S4: begin addr_sel=1'b1; start_calc=1'b1; end
        
      S6: begin
            SwrEn = (VDOT|SLH|SLL)? 1'b1: 1'b0;
            VwrEn = (VADD|SMUL|VLD)? 1'b1: 1'b0;
          end
        
    endcase
    end // end always
      
  
endmodule

module address_calculator(DataOut,out_addr,start_calc);
  input start_calc;
  input [15:0] DataOut;
  output reg [15:0] out_addr;
  assign offset={{10{DataOut[5]}},DataOut[5:0]};
  always@(*)
  begin
  if(start_calc)
    out_addr = offset+DataOut;
  else
    out_addr=out_addr;
  end // end always
endmodule


