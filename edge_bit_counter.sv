module Edge_bit_counter (
  input  wire             enable, RST, 
  input  wire             CLK , 
  input  wire    [5:0]    prescale,
  output reg     [5:0]    edge_cnt,
  output reg     [3:0]    bit_cnt   );
  
   always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        edge_cnt<=6'b0;
        bit_cnt <=4'b1;
      end
    else if(enable)
      begin
        case(prescale)
            6'd8: begin                                              //oversampling by  8
                    if(edge_cnt == 7)
                      begin
                       if(bit_cnt!=11)
                        begin
                         bit_cnt <= bit_cnt+1;
                         edge_cnt<=6'b0;
                        end
                       else
                        begin
                         bit_cnt<=4'b1;
                         edge_cnt<=6'b0;
                        end
                    end
                    else
                     edge_cnt <= edge_cnt+1;
                    end
            6'd16: begin                                                   //oversampling by  16
                     if(edge_cnt == 15)
                      begin
                       if(bit_cnt!=11)
                        begin
                         bit_cnt <= bit_cnt+1;
                         edge_cnt<=6'b0;
                        end
                       else
                        begin
                         bit_cnt<=4'b0;
                         edge_cnt<=6'b0;
                        end
                    end
                    else
                     edge_cnt <= edge_cnt+1;
                    end
            6'd32: begin                                                    //oversampling by 32
                     if(edge_cnt == 31)
                      begin
                       if(bit_cnt!=11)
                        begin
                         bit_cnt <= bit_cnt+1;
                         edge_cnt<=6'b0;
                        end
                       else
                        begin
                         bit_cnt<=4'b0;
                         edge_cnt<=6'b0;
                        end
                    end
                    else
                     edge_cnt <= edge_cnt+1;
                    end
          default : begin
                      bit_cnt <= bit_cnt;
                      edge_cnt <=edge_cnt;
                    end
        endcase
    end
  else
    begin
      bit_cnt<=4'b0;
      edge_cnt<=6'b0;
    end
  end
endmodule
