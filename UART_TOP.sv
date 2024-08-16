module UART_TOP # ( parameter DATA_WIDTH = 8)

(
 input   wire                          RST,
 input   wire                          TX_CLK,
 input   wire                          RX_CLK,
 input   wire                          RX_IN_S,
 output  wire   [DATA_WIDTH-1:0]       RX_OUT_P, 
 output  wire                          RX_OUT_V,
 input   wire   [DATA_WIDTH-1:0]       TX_IN_P, 
 input   wire                          TX_IN_V, 
 output  wire                          TX_OUT_S,
 output  wire                          TX_OUT_V,  
 input   wire   [5:0]                  Prescale, 
 input   wire                          parity_enable,
 input   wire                          parity_type,
 output  wire                          parity_error,
 output  wire                          framing_error
);

UART_TX  #(.DATA_WIDTH(DATA_WIDTH)) U0_UART_TX (
.CLK(TX_CLK),
.RST(RST),
.P_DATA(TX_IN_P),
.DATA_VALID(TX_IN_V),
.PAR_EN(parity_enable),
.PAR_TYP(parity_type), 
.TX_OUT(TX_OUT_S),
.BUSY(TX_OUT_V)           //BUSY signal out to the pulse generator
);
 
 
UART_RX_TOP U0_UART_RX (
.CLK(RX_CLK),
.RST(RST),
.RX_IN(RX_IN_S),
.prescale(Prescale),
.PAR_EN(parity_enable),
.PAR_TYP(parity_type),
.P_DATA(RX_OUT_P), 
.data_valid(RX_OUT_V),
.par_err(parity_error),
.stp_err(framing_error)
);
 



endmodule
 
