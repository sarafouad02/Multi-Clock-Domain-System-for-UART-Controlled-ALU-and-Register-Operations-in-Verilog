module BIT_SYNC # (
  parameter ADDR_SIZE  = 3,
  parameter PTR_SIZE   = 4,
  parameter NUM_STAGES = 2)
( input         [PTR_SIZE-1:0]  ptr,
  input                         clk,
  input                         rst_n,
  output  reg   [PTR_SIZE-1:0]  sync_ptr );
          
  //reg [PTR_SIZE-1:0] sync_ff1;

    // Synchronizer logic
   /* always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            // Reset the flip-flops
            sync_ff1 <= 'b0;
            sync_ptr <= 'b0;
        end else begin
            // Synchronize the signal
            sync_ff1 <= ptr;
            sync_ptr <= sync_ff1;
        end
    end*/
    
  reg [PTR_SIZE-1:0] sync_ff;
  
  always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      sync_ff<=0;
    else
      begin
        sync_ff<=ptr;
      end
    end
    always@(posedge clk or negedge rst_n)
    begin
    if(!rst_n)
      sync_ptr<=0;
    else
      begin
        sync_ptr<=sync_ff;
      end
    end
  endmodule
        

