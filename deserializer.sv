module Deserializer #(parameter WIDTH=8)(
  
  input  wire                   deser_en, RST, sampled_bit, 
  input  wire    [3:0]          bit_cnt,
  input  wire    [5:0]          edge_cnt, 
  input  wire    [5:0]          prescale,
  input  wire                   CLK , 
  output wire    [WIDTH-1:0]    P_DATA ); 
  
 reg [7:0] shift_reg; // Shift register to collect bits

 assign P_DATA = shift_reg;

  always @(posedge CLK or negedge RST)
   begin
    if (!RST) 
    begin
      //P_DATA <= 8'b0;
      shift_reg <= 8'b0;
    end
     else if (deser_en && edge_cnt == 1) 
     begin
     shift_reg <= {sampled_bit, shift_reg[7:1]};
      end 
      //else
        //P_DATA<=8'b0;
    end
endmodule
        