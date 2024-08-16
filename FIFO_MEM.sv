module FIFO_MEM #(
  parameter DATA_WIDTH = 8,
  parameter MEM_DEPTH  = 8,
  parameter ADDR_SIZE  = 3  ) (
  input     [DATA_WIDTH-1:0]    wdata,
  input                         w_inc , wfull,
  input     [ADDR_SIZE-1:0]     waddr, raddr,
  input                         w_clk, w_rst,
  output    [DATA_WIDTH-1:0]    rdata       );
  

  reg [4:0] i;
  reg [DATA_WIDTH-1:0] fifo_mem [0:MEM_DEPTH-1];
  
  always@(posedge w_clk or negedge w_rst)
    begin
      if(!w_rst)
        begin
        for (i = 0; i < MEM_DEPTH; i = i + 1) begin
            fifo_mem[i] <= 0; 
        end
      end
      else if(w_inc && !wfull)
        begin
          fifo_mem[waddr] <= wdata;
        end
      end
      

 assign rdata = fifo_mem[raddr];
      
endmodule
          
  
