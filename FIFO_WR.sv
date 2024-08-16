module FIFO_WR #(
 parameter ADDR_SIZE  = 3,
 parameter PTR_SIZE   = 4)
 ( input                        w_inc, w_rst_n,
   input                        w_clk,
   input  wire [PTR_SIZE-1:0]   gray_rd_ptr,
   output wire [ADDR_SIZE-1:0]  waddr,
   output                       wfull,
   output reg [PTR_SIZE-1:0]    gray_wptr_out     );
   
   /*reg [PTR_SIZE-1:0] wptr;
   wire wfull_comb;
   wire [PTR_SIZE-1:0] wptr_comb;
   reg [PTR_SIZE-1:0]   gray_wr_ptr;
   
  always @(*)
        begin
          case (wptr_comb)
            4'b0000: gray_wr_ptr = 4'b0000 ;
            4'b0001: gray_wr_ptr = 4'b0001 ;
            4'b0010: gray_wr_ptr = 4'b0011 ;
            4'b0011: gray_wr_ptr = 4'b0010 ;
            4'b0100: gray_wr_ptr = 4'b0110 ;
            4'b0101: gray_wr_ptr = 4'b0111 ;
            4'b0110: gray_wr_ptr = 4'b0101 ;
            4'b0111: gray_wr_ptr = 4'b0100 ;
            4'b1000: gray_wr_ptr = 4'b1100 ;
            4'b1001: gray_wr_ptr = 4'b1101 ;
            4'b1010: gray_wr_ptr = 4'b1111 ;
            4'b1011: gray_wr_ptr = 4'b1110 ;
            4'b1100: gray_wr_ptr = 4'b1010 ;
            4'b1101: gray_wr_ptr = 4'b1011 ;
            4'b1110: gray_wr_ptr = 4'b1001 ;
            4'b1111: gray_wr_ptr = 4'b1000 ;
            default : gray_wr_ptr = gray_wr_ptr;
          endcase
      end
      

 // Update pointers and Gray code on clock or reset
  always @(posedge w_clk or negedge w_rst_n) begin
    if (!w_rst_n) begin
      {gray_wptr_out, wptr} <= 0;
    end else begin
      {gray_wptr_out, wptr} <= {gray_wr_ptr,wptr_comb};
    end
  end
  
assign wptr_comb = wptr + (w_inc && !wfull);

        
   always@(posedge w_clk or negedge w_rst_n)
    begin
      if(!w_rst_n)
        begin
          wfull <=1'b0;
        end
      else
            begin
              wfull <= wfull_comb;
          end
       end   
assign  wfull_comb = gray_wptr_out[PTR_SIZE-1]!= gray_rd_ptr[PTR_SIZE-1] && gray_wptr_out[PTR_SIZE-2]!=gray_rd_ptr[PTR_SIZE-2] &&gray_wptr_out[PTR_SIZE-3:0]==gray_rd_ptr[PTR_SIZE-3:0];
        
  assign  waddr = wptr_comb[ADDR_SIZE-1:0];
  

        endmodule
   */
   
reg [PTR_SIZE-1:0]  w_ptr ;

// increment binary pointer
always @(posedge w_clk or negedge w_rst_n)
 begin
  if(!w_rst_n)
   begin
    w_ptr <= 0 ;
   end
 else if (!wfull && w_inc)
    w_ptr <= w_ptr + 1 ;
 end


// generation of write address
assign waddr = w_ptr[PTR_SIZE-2:0] ;

// converting binary write pointer to gray coded
always @(posedge w_clk or negedge w_rst_n)
 begin
  if(!w_rst_n)
   begin
    gray_wptr_out <= 0 ;
   end
 else
  begin
   case (w_ptr)
   4'b0000: gray_wptr_out <= 4'b0000 ;
   4'b0001: gray_wptr_out <= 4'b0001 ;
   4'b0010: gray_wptr_out <= 4'b0011 ;
   4'b0011: gray_wptr_out <= 4'b0010 ;
   4'b0100: gray_wptr_out <= 4'b0110 ;
   4'b0101: gray_wptr_out <= 4'b0111 ;
   4'b0110: gray_wptr_out <= 4'b0101 ;
   4'b0111: gray_wptr_out <= 4'b0100 ;
   4'b1000: gray_wptr_out <= 4'b1100 ;
   4'b1001: gray_wptr_out <= 4'b1101 ;
   4'b1010: gray_wptr_out <= 4'b1111 ;
   4'b1011: gray_wptr_out <= 4'b1110 ;
   4'b1100: gray_wptr_out <= 4'b1010 ;
   4'b1101: gray_wptr_out <= 4'b1011 ;
   4'b1110: gray_wptr_out <= 4'b1001 ;
   4'b1111: gray_wptr_out <= 4'b1000 ;
   endcase
  end
 end


// generation of full flag
assign wfull = (gray_rd_ptr[PTR_SIZE-1]!= gray_wptr_out[PTR_SIZE-1] && gray_rd_ptr[PTR_SIZE-2]!= gray_wptr_out[PTR_SIZE-2] && gray_rd_ptr[PTR_SIZE-3:0]== gray_wptr_out[PTR_SIZE-3:0]) ;



endmodule




          
   
   
   
