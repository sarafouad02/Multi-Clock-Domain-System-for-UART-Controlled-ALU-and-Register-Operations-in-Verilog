module ASYNC_FIFO_TOP #(
  parameter ADDR_SIZE  = 3,
  parameter PTR_SIZE   = 4,
  parameter DATA_WIDTH = 8,
  parameter MEM_DEPTH  = 8 )
  
( input                              w_clk,r_clk,
  input                              w_rst, r_rst, w_inc, r_inc,
  input       [DATA_WIDTH-1:0]       wdata,
  output                             full, empty,
  output      [DATA_WIDTH-1:0]       rdata                       );
  
  
  wire [ADDR_SIZE-1:0] waddr, raddr;
  wire [PTR_SIZE-1:0]  w_ptr, rptr, wq2_rptr, rq2_wptr;

FIFO_MEM FIFO_MEM (
.w_inc(w_inc),
.wfull(full),
.wdata(wdata),
.rdata(rdata),
.waddr(waddr),
.raddr(raddr),
.w_clk(w_clk),
.w_rst(w_rst)  );

FIFO_WR FIFO_WR(
.w_clk(w_clk),
.w_rst_n(w_rst),
.w_inc(w_inc),
.wfull(full),
.waddr(waddr),
.gray_wptr_out(w_ptr),
.gray_rd_ptr(wq2_rptr) );

FIFO_RD FIFO_RD (
.r_clk(r_clk),
.r_rst_n(r_rst),
.gray_rd_ptr(rptr),
.gray_wr_ptr(rq2_wptr),
.r_inc(r_inc),
.rempty(empty),
.raddr(raddr) );

BIT_SYNC SYNC_R2W(
.ptr(rptr),
.clk(w_clk),
.rst_n(w_rst),
.sync_ptr(wq2_rptr) );

BIT_SYNC SYNC_W2R(
.ptr(w_ptr),
.clk(r_clk),
.rst_n(r_rst),
.sync_ptr(rq2_wptr) );


endmodule
  
  