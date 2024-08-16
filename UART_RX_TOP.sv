module UART_RX_TOP (
  input wire            CLK,
  input wire            RST, RX_IN, PAR_EN, PAR_TYP,
  input wire    [5:0]   prescale,
  output wire   [7:0]   P_DATA,
  output wire           data_valid, par_err, stp_err );
  
  //internal connections
  wire           enable, dat_samp_en, par_chk_en, strt_chk_en, stp_chk_en, strt_glitch;
  wire           sampled_bit, deser_en;
  wire    [3:0]  bit_cnt;
  wire    [5:0]  edge_cnt;
  
  Parity_check PARITY_CHECK(
  .CLK(CLK) ,
  .RST(RST),
  .PAR_TYP(PAR_TYP),
  .par_chk_en(par_chk_en) ,
  .par_err(par_err),
  .sampled_bit(sampled_bit),
  .P_DATA(P_DATA),
  .prescale(prescale),
  .edge_cnt(edge_cnt),
  .bit_cnt(bit_cnt) );
  
  Stop_check STOP_CHECK(
  .CLK(CLK),
  .RST(RST),
  .stp_chk_en(stp_chk_en),
  .stp_err(stp_err),
  .sampled_bit(sampled_bit),
  .prescale(prescale),
  .edge_cnt(edge_cnt),
  .bit_cnt(bit_cnt) );
  
  Start_check START_CHECK(
  .CLK(CLK),
  .RST(RST),
  .strt_chk_en(strt_chk_en),
  .sampled_bit(sampled_bit),
  .strt_glitch(strt_glitch),
  .prescale(prescale),
  .edge_cnt(edge_cnt),
  .bit_cnt(bit_cnt)  );
  
  Edge_bit_counter EDGE_BIT_COUNTER (
  .CLK(CLK),
  .RST(RST),
  .bit_cnt(bit_cnt) ,
  .edge_cnt(edge_cnt),
  .enable(enable),
  .prescale(prescale) );
  
  Data_sampling DATA_SAMPLING (
  .CLK(CLK),
  .dat_samp_en(dat_samp_en),
  .RST(RST),
  .prescale(prescale),
  .edge_cnt(edge_cnt),
  .RX_IN(RX_IN),
  .sampled_bit(sampled_bit),
  .bit_cnt(bit_cnt)
  );
  
  Deserializer DESERIALIZER (
  .CLK(CLK),
  .RST(RST),
  .sampled_bit(sampled_bit),
  .P_DATA(P_DATA),
  .deser_en(deser_en),
  .edge_cnt(edge_cnt),
  .prescale(prescale),
  .bit_cnt(bit_cnt) );
  
  UART_RX_FSM UART_RX_FSM (
  .RX_IN(RX_IN), 
  .PAR_EN(PAR_EN),
  .RST(RST),
  .CLK(CLK),
  .prescale(prescale),
  .bit_cnt(bit_cnt),
  .edge_cnt(edge_cnt),
  .enable(enable),
  .dat_samp_en(dat_samp_en),
  .par_chk_en(par_chk_en),
  .par_err(par_err),
  .strt_chk_en(strt_chk_en),
  .strt_glitch(strt_glitch),
  .stp_chk_en(stp_chk_en),
  .stp_err(stp_err),
  .data_valid(data_valid),
  .deser_en(deser_en) );
  
endmodule
  


  
  
