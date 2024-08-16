module MUX_UART (
  input wire [3:0] MUX_SEL,
  input wire PAR_bit, SER_DATA,
  input wire CLK,
  output reg TX_OUT );
  
  parameter START_bit = 1'b0;
  parameter STOP_bit  = 1'b1;
  
   always@(*)
    //begin
     //if(!RST)
      // begin
        // TX_OUT <=1'b1;
        //end
     //else
       begin
        case(MUX_SEL)
          4'b0000: begin
                    TX_OUT <= 1'b1;
                   end
          4'b0001: begin
                    TX_OUT <= START_bit;
                   end
          4'b0010: begin
                    TX_OUT <= SER_DATA;
                   end         
          4'b0011: begin
                    TX_OUT <= PAR_bit;
                   end
          4'b0100: begin
                    TX_OUT <= STOP_bit;
                   end
         
        default :   TX_OUT <= 1'b1;
       endcase

  end
endmodule
