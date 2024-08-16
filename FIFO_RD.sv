module FIFO_RD # (
  parameter ADDR_SIZE  = 3,
  parameter PTR_SIZE   = 4)
 ( input                        r_inc, r_rst_n,
   input                        r_clk,
   input  	 [PTR_SIZE-1:0]    gray_wr_ptr,
   output reg [PTR_SIZE-1:0]    gray_rd_ptr,
   output wire [ADDR_SIZE-1:0]  raddr,
   output wire                   rempty     );
   
   reg [PTR_SIZE-1:0] rptr;

   
   
always @(*)
        begin
          case (rptr)
            4'b0000: gray_rd_ptr = 4'b0000 ;
            4'b0001: gray_rd_ptr = 4'b0001 ;
            4'b0010: gray_rd_ptr = 4'b0011 ;
            4'b0011: gray_rd_ptr = 4'b0010 ;
            4'b0100: gray_rd_ptr = 4'b0110 ;
            4'b0101: gray_rd_ptr = 4'b0111 ;
            4'b0110: gray_rd_ptr = 4'b0101 ;
            4'b0111: gray_rd_ptr = 4'b0100 ;
            4'b1000: gray_rd_ptr = 4'b1100 ;
            4'b1001: gray_rd_ptr = 4'b1101 ;
            4'b1010: gray_rd_ptr = 4'b1111 ;
            4'b1011: gray_rd_ptr = 4'b1110 ;
            4'b1100: gray_rd_ptr = 4'b1010 ;
            4'b1101: gray_rd_ptr = 4'b1011 ;
            4'b1110: gray_rd_ptr = 4'b1001 ;
            4'b1111: gray_rd_ptr = 4'b1000 ;
          endcase
         end

      
  always@(posedge r_clk or negedge r_rst_n)
    begin
      if(!r_rst_n)
        begin
          rptr  <= 'b0;
        end
          else if(r_inc&& ~rempty)
            begin
              rptr <= rptr+1;
            end
        end 
  assign rempty = gray_wr_ptr == gray_rd_ptr;      


  assign  raddr = rptr[ADDR_SIZE-1:0];

endmodule
   
