module parity_calc (
  input  wire             DATA_VALID ,PAR_TYP, RST, BUSY,
  input  wire             CLK , 
  input  wire    [7:0]    P_DATA,
  output reg              PAR_bit
  
  );
  
  always @(posedge CLK or negedge RST)
  begin
    if(!RST)
      PAR_bit<=1'b0;
  else if(DATA_VALID&&!BUSY)
     begin
      case(PAR_TYP)
        1'b0: begin
                 PAR_bit <= ^P_DATA; // even parity
                end
        1'b1: begin
                PAR_bit <= ~^P_DATA; // odd parity
                end
          endcase
      end
   else
     PAR_bit<=PAR_bit;
  end
 endmodule      