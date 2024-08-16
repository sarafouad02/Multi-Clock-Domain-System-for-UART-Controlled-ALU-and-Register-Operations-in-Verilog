module SYS_CONTROL (
  input CLK,
  input RST, ALU_OUT_VALID, RX_D_VLD,
  input [7:0] RX_P_DATA, RdData,
  input Rd_Data_Valid, FIFO_FULL,
  input [15:0] ALU_OUT,
  output reg ALU_EN, CLK_EN, WrEn, RdEn, clk_div_en, WR_INC,
  output reg [3:0] ALU_FUN, Address,
  output reg [7:0] WrData, TX_P_DATA
);

  localparam IDLE           = 4'b0000,
             RF_WR_ADDR     = 4'b0001,
             RF_WR_DATA     = 4'b0010,
             RF_RD_ADDR     = 4'b0011,
             OP_A           = 4'b0100,
             OP_B           = 4'b0101,
             Alu_FUN        = 4'b0110,
             FIFO_RD        = 4'b0111,
             FIFO_ALU_LSB   = 4'b1000,
             FIFO_ALU_MSB   = 4'b1001;
             
  reg [3:0]  current_state, next_state;
  reg [3:0]  ALU_FUN_SEQ, Address_seq;  
  reg CLK_EN_SEQ, ALU_EN_SEQ;

  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end

  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
      Address_seq <= 'b0;
      CLK_EN_SEQ <= 'b0;
      ALU_FUN_SEQ <= 'b0;
      ALU_EN_SEQ <= 'b0;
    end else begin
      Address_seq <= Address;
      CLK_EN_SEQ <= CLK_EN;
      ALU_FUN_SEQ <= ALU_FUN;
      ALU_EN_SEQ <= ALU_EN;
    end
  end

  always @(*) begin
    ALU_EN = ALU_EN_SEQ;
    CLK_EN = CLK_EN_SEQ;
    WrEn = 'b0;
    RdEn = 'b0;
    clk_div_en = 'b1; 
    WR_INC = 'b0;
    ALU_FUN = ALU_FUN_SEQ;
    Address = Address_seq;
    WrData = 'b0;
    TX_P_DATA = 'b0;
    
    case (current_state)
      IDLE: begin
        if (RX_D_VLD) begin
          case(RX_P_DATA)
            8'hAA: begin
              WrEn = 1'b1;
              next_state = RF_WR_ADDR;
            end
            8'hBB: begin 
              next_state = RF_RD_ADDR;
            end
            8'hCC: begin
              next_state = OP_A;
            end
            8'hDD: begin
              next_state = Alu_FUN;
            end
            default: next_state = IDLE;
          endcase
        end else begin
          next_state = current_state;
        end
      end

      RF_WR_ADDR: begin
        if (RX_D_VLD) begin
          WrEn = 1'b1;
          Address = RX_P_DATA[3:0];
          next_state = RF_WR_DATA;
        end else begin
          next_state = current_state;
        end
      end

      RF_WR_DATA: begin
        if (RX_D_VLD) begin
          WrEn = 1'b1;
          WrData = RX_P_DATA;
          next_state = IDLE;
        end else begin
          next_state = current_state;
        end
      end

      RF_RD_ADDR: begin
        if (RX_D_VLD) begin
          RdEn = 1'b1;
          Address = RX_P_DATA[3:0];
          next_state = FIFO_RD;
        end else begin
          next_state = current_state;
        end
      end

      OP_A: begin
        if (RX_D_VLD) begin
          WrEn = 1'b1;
          Address = 'b0;
          WrData = RX_P_DATA;
          next_state = OP_B;
        end else begin
          next_state = current_state;
        end
      end

      OP_B: begin
        if (RX_D_VLD) begin
          WrEn = 1'b1;
          Address = 'b1;
          WrData = RX_P_DATA;
          next_state = Alu_FUN;
        end else begin
          next_state = current_state;
        end
      end

      Alu_FUN: begin
        if (RX_D_VLD) begin
          ALU_EN = 1'b1;
          CLK_EN = 1'b1;
          ALU_FUN = RX_P_DATA;
          next_state = FIFO_ALU_LSB;
        end else begin
          next_state = current_state;
        end
      end

      FIFO_RD: begin
        if (Rd_Data_Valid) begin
          WR_INC = 1'b1;
          TX_P_DATA = RdData;
          next_state = IDLE;
        end else begin
          next_state = current_state;
        end
      end

      FIFO_ALU_LSB: begin
        if (ALU_OUT_VALID && !FIFO_FULL) begin
          TX_P_DATA = ALU_OUT[7:0]; // Send LSB first
          WR_INC = 1'b1;
          next_state = FIFO_ALU_MSB;
        end else begin
          next_state = current_state;
        end
      end

      FIFO_ALU_MSB: begin
        if (ALU_OUT_VALID && !FIFO_FULL) begin
          TX_P_DATA = ALU_OUT[15:8]; // Send MSB next
          WR_INC = 1'b1;
          next_state = IDLE;
        end else begin
          next_state = current_state;
        end
      end

      default: begin
        ALU_EN = 'b0;
        CLK_EN = CLK_EN;
        WrEn = 'b0;
        RdEn = 1'b0;
        clk_div_en = 'b1; 
        WR_INC = 'b0;
        ALU_FUN = 'b0;
        Address = 'b0;
        WrData = 'b0;
        TX_P_DATA = 'b0;
        next_state = current_state;
      end
    endcase
  end
endmodule
