`timescale 1 ns / 1 ns
module t_cpu();
  reg Clk1,Clk2,Reset;
  wire [15:0] DataIn,DataOut,Addr;
  wire RD,WR;
  wire V;
 
  CVP14 DUT(Addr, RD, WR, V, DataOut, Reset,Clk1,Clk2, DataIn);
  staticram sram(DataIn, Addr, DataOut, Clk1, Clk2, RD, WR);
  
  initial
  begin
  Clk1=1'b0;
  Clk2=1'b0;
  end
  
  initial
  begin
  forever begin 
    Clk1=1;
    #5 Clk1=0;
    #15;
    end
  end
  
  initial
  begin
  #10;
  forever begin 
    Clk2=1;
    #5 Clk2=0;
    #15;
    end
  end
  
  initial
  begin
    Reset=1'b1;
    #26 Reset=1'b0;
    
  end
    
  
endmodule
