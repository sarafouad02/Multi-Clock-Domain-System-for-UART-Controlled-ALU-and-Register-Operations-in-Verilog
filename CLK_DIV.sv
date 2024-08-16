module ClkDiv (
  input wire          I_ref_clk,
  input wire          I_rst_n,
  input wire          I_clk_en,
  input wire   [7:0]  I_div_ratio,
  output reg          o_div_clk 
);

  wire is_odd;
  reg flag = 1'b1;
  integer counter = 1;
  wire clk_div_en;
  reg div_clk;  // Register to hold the divided clock

  // Clock division logic
  always @(posedge I_ref_clk or negedge I_rst_n) begin
    if (!I_rst_n) begin
      counter <= 1;
      div_clk <= 1'b0;
      flag <= 1'b1;
    end else if (clk_div_en) begin
      if ((counter == (I_div_ratio >> 1)) && !is_odd) begin
        div_clk <= ~div_clk;
        counter <= 1;
      end else if (((counter == (I_div_ratio >> 1)) && !flag) ||
                   ((counter == (I_div_ratio >> 1) + 1) && flag)) begin
        div_clk <= ~div_clk;
        flag <= ~flag;
        counter <= 1;
      end else begin
        counter <= counter + 1;
      end
    end else begin
      counter <= 1;
      flag <= 1'b1;
    end
  end

  // Mux to select between the divided clock and the reference clock
  always @(*) begin
    if (clk_div_en)
      o_div_clk = div_clk;
    else
      o_div_clk = I_ref_clk;
  end

  assign clk_div_en = I_clk_en && (I_div_ratio != 8'b0) && (I_div_ratio != 8'b1);
  assign is_odd = I_div_ratio[0];

endmodule

  

  
