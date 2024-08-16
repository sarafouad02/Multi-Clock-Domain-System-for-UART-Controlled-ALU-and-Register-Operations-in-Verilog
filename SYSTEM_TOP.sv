module SYSTEM_TOP #( parameter DATA_WIDTH = 8, ADDR_SIZE = 4)
  (input  wire  REF_CLK,
  input    RST,
  input  wire  UART_CLK,
  input    RX_IN,
  output   TX_OUT, parity_error, framing_error );
  
  ////////////////////RF////////////////////
  
  wire                                  WrEn_RF, RdEn_RF, RF_RdData_VLD;
  wire [DATA_WIDTH-1:0]                 WrData_RF, RdData_RF;
  wire [ADDR_SIZE-1:0]                  RF_Addr ; 
  
  //////////////////////ALU//////////////////////
  
  wire                                   ALU_EN, ALU_CLK, ALU_OUT_VALID;
  wire      [DATA_WIDTH*2-1:0]           ALU_OUT;
  wire      [DATA_WIDTH-1:0]             OPERAND_A, OPERAND_B;
  wire      [ADDR_SIZE-1:0]              ALU_FUN ;     
  
  /////////////////////RX//////////////////////////
  
  wire                                   UART_RX_V_OUT, UART_RX_V_SYNC;
  wire [DATA_WIDTH-1:0]                  UART_RX_OUT, UART_RX_SYNC, UART_Config; 
  
  ////////////////////FIFO//////////////////////////////
  
  wire                                    F_EMPTY, WR_INC, FIFO_FULL; //RD_INC;
  wire [DATA_WIDTH-1:0]                   WrData_FIFO, RdData_FIFO;
  
  ////////////////////////SIMULTANEOUS///////////////////////////
  
  wire                                    GATE_EN, RST_SYNC_1,RST_SYNC_2,  CLKDIV_EN;
  wire                                    BUSY_TX, UART_TX_BUSY_PULSE , RX_CLK, TX_CLK;
  wire                                    [DATA_WIDTH-1:0]  DIV_RATIO,DIV_RATIO_RX;
  
  ////////////////////////////////////////////////////////////////
 
RST_SYNC # (.NUM_STAGES(2)) U1_RST_SYNC (
.RST(RST),
.CLK(REF_CLK),                                  //RST_SYNC_1
.SYNC_RST(RST_SYNC_1)
);
 
RST_SYNC # (.NUM_STAGES(2)) RST_SYNC (
.RST(RST),
.CLK(UART_CLK),
.SYNC_RST(RST_SYNC_2)      //RST_SYNC_2   sync_uart_rst
);


DATA_SYNC # (.NUM_STAGES(2) , .BUS_WIDTH(8)) DATA_SYNC (
.CLK(REF_CLK),
.RST(RST_SYNC_1),
.unsync_bus(UART_RX_OUT),
.bus_enable(UART_RX_V_OUT),
.sync_bus_delayed(UART_RX_SYNC),
.enable_pulse(UART_RX_V_SYNC)
);

CLK_GATE CLK_GATE (
.CLK_EN(GATE_EN),
.CLK(REF_CLK),
.GATED_CLK(ALU_CLK)
);


 ALU_Design  ALU(
 .A(OPERAND_A),
 .B(OPERAND_B),
 .ALU_FUN(ALU_FUN),
 .OUT_VALID(ALU_OUT_VALID),
 .CLK(ALU_CLK),
 .EN(ALU_EN),
 .RST(RST_SYNC_1),
 .ALU_OUT(ALU_OUT) );
 

ASYNC_FIFO_TOP #(.DATA_WIDTH(DATA_WIDTH) , .PTR_SIZE(4)  , .MEM_DEPTH(8)) FIFO (
.w_clk(REF_CLK),
.w_rst(RST_SYNC_1),  
.w_inc(WR_INC),
.wdata(WrData_FIFO),             
.r_clk(TX_CLK),              
.r_rst(RST_SYNC_2),              
.r_inc(UART_TX_BUSY_PULSE),              
.rdata(RdData_FIFO),             
.full(FIFO_FULL),               
.empty(F_EMPTY)       // UART_TX VALID SYNC        
);

PULSE_GEN PULSE_GEN (
.CLK(TX_CLK),
.RST(RST_SYNC_2),
.lvl_sig(BUSY_TX),
.pulse_sig(UART_TX_BUSY_PULSE)
);


  
  ClkDiv CLKDIV_RX (
.I_ref_clk(UART_CLK),             
.I_rst_n(RST_SYNC_2),                 
.I_clk_en(CLKDIV_EN),               
.I_div_ratio(DIV_RATIO_RX),           
.o_div_clk(RX_CLK)             
);


ClkDiv CLKDIV_TX (
.I_ref_clk(UART_CLK),             
.I_rst_n(RST_SYNC_2),                 
.I_clk_en(CLKDIV_EN),               
.I_div_ratio(DIV_RATIO),           
.o_div_clk(TX_CLK)             
);

CLKDIV_MUX CLKDIV_MUX (
.IN(UART_Config[7:2]),
.OUT(DIV_RATIO_RX)
);




UART_TOP  UART (
.RST(RST_SYNC_2),
.TX_CLK(TX_CLK),
.RX_CLK(RX_CLK),
.parity_enable(UART_Config[0]),
.parity_type(UART_Config[1]),
.Prescale(UART_Config[7:2]),
.RX_IN_S(RX_IN),
.RX_OUT_P(UART_RX_OUT),                      
.RX_OUT_V(UART_RX_V_OUT),                      
.TX_IN_P(RdData_FIFO), 
.TX_IN_V(!F_EMPTY), 
.TX_OUT_S(TX_OUT),
.TX_OUT_V(BUSY_TX),
.parity_error(parity_error),
.framing_error(framing_error)                  
);




RegFile RegFile (
.CLK(REF_CLK),
.RST(RST_SYNC_1),
.WrEn(WrEn_RF),
.RdEn(RdEn_RF),
.Address(RF_Addr),
.WrData(WrData_RF),
.RdData(RdData_RF),
.RdData_VLD(RF_RdData_VLD),
.REG0(OPERAND_A),
.REG1(OPERAND_B),
.REG2(UART_Config),
.REG3(DIV_RATIO)
);
  
SYS_CONTROL SYS_CTRL (
.CLK(REF_CLK),
.RST(RST_SYNC_2),
.RdData(RdData_RF),
.Rd_Data_Valid(RF_RdData_VLD),
.WrEn(WrEn_RF),
.RdEn(RdEn_RF),
.Address(RF_Addr),
.WrData(WrData_RF),
.ALU_EN(ALU_EN),
.ALU_FUN(ALU_FUN), 
.ALU_OUT(ALU_OUT),
.ALU_OUT_VALID(ALU_OUT_VALID),  
.CLK_EN(GATE_EN), 
.clk_div_en(CLKDIV_EN),   
.FIFO_FULL(FIFO_FULL),
.RX_P_DATA(UART_RX_SYNC), 
.RX_D_VLD(UART_RX_V_SYNC),
.TX_P_DATA(WrData_FIFO), 
.WR_INC(WR_INC)
);
endmodule
