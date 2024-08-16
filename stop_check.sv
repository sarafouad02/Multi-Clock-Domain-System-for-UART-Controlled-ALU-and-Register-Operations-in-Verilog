module Stop_check (
   
  input  wire             stp_chk_en, RST, sampled_bit,
  input  wire    [5:0]    prescale,
  input wire     [5:0]    edge_cnt,
  input wire     [3:0]    bit_cnt,   
  input  wire             CLK ,  
  output reg              stp_err );
    
always@(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        stp_err<=1'b0;
      end
    else if (stp_chk_en && edge_cnt==0)
      begin
        if(sampled_bit!=1'b1)
          stp_err<=1'b1;
        else
          stp_err<=1'b0;
      end
    else
      stp_err<=stp_err;
  end
endmodule
          