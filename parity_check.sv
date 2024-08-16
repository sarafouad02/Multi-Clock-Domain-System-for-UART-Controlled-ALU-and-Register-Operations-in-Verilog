module Parity_check (
   
  input  wire             PAR_TYP ,par_chk_en, RST, sampled_bit,
  input  wire             CLK , 
  input  wire    [7:0]    P_DATA,
  input  wire    [5:0]    prescale,
  input wire     [5:0]    edge_cnt,
  input wire     [3:0]    bit_cnt,   
  output reg              par_err 
  );
  wire PAR_bit;
  
 assign PAR_bit = (PAR_TYP)?(~^P_DATA):(^P_DATA);
  
always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        par_err<=1'b0;
      end
    else if (par_chk_en && edge_cnt== 1)
      begin
           case(PAR_TYP)
            1'b0: begin                                                   
                  if(PAR_bit==sampled_bit)
                    par_err<=1'b0;
                  else
                    par_err<=1'b1;   
                  end
            1'b1: begin                                                                                                     
                  if(PAR_bit==sampled_bit)
                    par_err<=1'b0;
                  else
                    par_err<=1'b1;                
                  end       
          default : par_err<=1'b0;
        endcase
      end
    else
      par_err <= par_err;
    end
endmodule
        
  
