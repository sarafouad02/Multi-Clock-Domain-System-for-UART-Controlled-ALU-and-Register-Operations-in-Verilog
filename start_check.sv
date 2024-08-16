module Start_check (
   
  input  wire             strt_chk_en, RST, sampled_bit,
  input  wire             CLK ,  
  input  wire    [5:0]    prescale,
  input wire     [5:0]    edge_cnt,
  input wire     [3:0]    bit_cnt,   
  output reg              strt_glitch );
  
  always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        strt_glitch<=1'b0;
      end
    else if (strt_chk_en && edge_cnt == prescale-1 && bit_cnt==1)
      begin
        if(sampled_bit!=1'b0)
          strt_glitch<=1'b1;
        else
          strt_glitch<=1'b0;
      end
    else
      strt_glitch<=1'b0;
  end
endmodule