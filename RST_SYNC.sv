module RST_SYNC # (
  parameter NUM_STAGES = 2 )
  (  input CLK,
     input RST,
     output wire SYNC_RST );
     
     
reg   [NUM_STAGES-1:0]    stage_reg;


always @(posedge CLK or negedge RST)
 begin
  if(!RST)      // active low
   begin
    stage_reg <= 'b0 ;
   end
  else
   begin
    stage_reg <= {stage_reg[NUM_STAGES-2:0],1'b1};
   end  
 end
 
 
assign  SYNC_RST = stage_reg[NUM_STAGES-1] ;
endmodule
