module Data_sampling (
  
  input  wire             RX_IN ,dat_samp_en, RST, 
  input  wire             CLK , 
  input  wire    [5:0]    prescale,
  input wire     [5:0]    edge_cnt,
  input wire     [3:0]    bit_cnt,
  output reg              sampled_bit
   );
  
  integer counter = 0;
  
  always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        counter <= 0;
      end
      else if(dat_samp_en)
          begin
           case(prescale)
            6'd8: begin                                                     //oversampling by  8
                    if(edge_cnt == 3 || edge_cnt == 4 || edge_cnt == 5)
                        counter <= counter + RX_IN;
                    else if(edge_cnt == 6)
                        begin
                          if(counter == 2 || counter == 3) 
                           begin
                            sampled_bit <= 1'b1;
                            counter <= 0;
                           end
                          else 
                           begin
                            sampled_bit <= 1'b0; 
                            counter <= 0;
                          end
                        end
                     else
                      sampled_bit <= sampled_bit;
                      end
            6'd16: begin                                                   //oversampling by  16
                      if(edge_cnt == 7 || edge_cnt == 8 || edge_cnt == 9)
                        counter <= counter + RX_IN;
                      else if(edge_cnt == 10)
                        begin
                          if(counter == 2 || counter == 3) 
                           begin
                            sampled_bit <= 1'b1;
                            counter <= 0;
                          end
                          else 
                           begin
                            sampled_bit <= 1'b0; 
                            counter <= 0;
                           end
                        end
                     else
                      sampled_bit <= sampled_bit;
                     end
            6'd32: begin                                                    //oversampling by 32
                     if(edge_cnt == 15 || edge_cnt == 16 || edge_cnt == 17)
                        counter <= counter + RX_IN;
                      else if(edge_cnt == 18)
                        begin
                          if(counter == 2 || counter == 3) 
                           begin
                            sampled_bit <= 1'b1;
                            counter <= 0;
                          end
                          else 
                           begin
                            sampled_bit <= 1'b0; 
                            counter <= 0;
                           end
                        end
                      else
                       sampled_bit <= sampled_bit;
                      end
          default : sampled_bit <=sampled_bit;
        endcase
      end
     else
       begin
        sampled_bit <= sampled_bit;
        counter<=0;
       end
     end
  endmodule