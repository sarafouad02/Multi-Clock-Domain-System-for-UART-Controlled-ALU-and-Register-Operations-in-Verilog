module PULSE_GEN 
(
input    wire                      CLK,
input    wire                      RST,
input    wire                      lvl_sig,
output   wire                      pulse_sig
);


reg              rcv_flop  , 
                 pls_flop  ;
					 
					 
always @(posedge CLK or negedge RST)
 begin
  if(!RST)      // active low
   begin
    rcv_flop <= 1'b0 ;
    pls_flop <= 1'b0 ;	
   end
  else
   begin
    rcv_flop <= lvl_sig;   
    pls_flop <= rcv_flop;
   end  
 end
 


assign pulse_sig = rcv_flop && !pls_flop ;


endmodule
