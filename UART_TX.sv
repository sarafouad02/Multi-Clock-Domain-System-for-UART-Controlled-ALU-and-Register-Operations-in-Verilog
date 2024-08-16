module UART_TX #(parameter DATA_WIDTH = 8)(
  input wire CLK,
  input wire DATA_VALID,PAR_EN,PAR_TYP,RST,
  input wire [DATA_WIDTH-1:0] P_DATA,
  output wire TX_OUT, BUSY
  );
  
  //internal connections
  wire SER_DONE, SER_EN, SER_DATA, PAR_bit;
  wire [3:0] MUX_SEL;
  
  //parity 
  parity_calc PARITY_CALC (
  .CLK(CLK),
  .RST(RST),
  .PAR_TYP(PAR_TYP),
  .DATA_VALID(DATA_VALID),
  .P_DATA(P_DATA),
  .PAR_bit(PAR_bit),
  .BUSY(BUSY));
  
  //serializer 
  serializer SERIALIZER (
  .CLK(CLK),
  .RST(RST),
  .P_DATA(P_DATA),
  .DATA_VALID(DATA_VALID),
  .SER_DONE(SER_DONE),
  .SER_EN(SER_EN),
  .SER_DATA(SER_DATA), 
  .BUSY(BUSY));
  
  // FSM
 UART_FSM FSM_UART (
  .CLK(CLK),
  .RST(RST),
  .PAR_EN(PAR_EN),
  .DATA_VALID(DATA_VALID),
  .SER_DONE(SER_DONE),
  .SER_EN(SER_EN),
  .BUSY(BUSY),
  .MUX_SEL(MUX_SEL));
  
  //MUX
  
  MUX_UART MUX_UART (
  .CLK(CLK),
  .MUX_SEL(MUX_SEL),
  .TX_OUT(TX_OUT),
  .SER_DATA(SER_DATA),
  .PAR_bit(PAR_bit));
  
endmodule
  
  
  
  
  
  
  
  
