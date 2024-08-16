module UART_FSM (
  input  wire             DATA_VALID, RST, PAR_EN, SER_DONE,
  input  wire             CLK , 
  output reg              BUSY, SER_EN, 
  output reg     [3:0]    MUX_SEL
  );


localparam IDLE      = 3'd0;
localparam START_ST  = 3'd1;
localparam DATA_ST   = 3'd2;
localparam PARITY_ST = 3'd3;
localparam STOP_ST   = 3'd4;

// Declare state variables
reg [2:0] current_state, next_state;

// state transition 		
always @(posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
     current_state <= IDLE ;
   end
  else
   begin
     current_state <= next_state ;
   end
 end
 
  
 // next_state logic
always @(*)
 begin
  case(current_state)
  IDLE:     begin
             if(DATA_VALID)
              begin
                next_state = START_ST;
              end
             else
                next_state = IDLE;
             end
             
  START_ST:   begin
               next_state = DATA_ST;
              end
             
  DATA_ST:    begin
              
               if(SER_DONE)
                 begin
                   if(PAR_EN)
                    next_state = PARITY_ST;
                  else
                    next_state = STOP_ST;
                  end
               else
                 next_state = DATA_ST;
                 
              end
             
  PARITY_ST:  begin
               next_state = STOP_ST;
              end
             
  STOP_ST:    begin
                next_state = IDLE;
               end
 
  default :   next_state = IDLE;		 
  
  endcase
end	

 //output logic
 always @(*)
 begin
  case(current_state)
  IDLE:      begin
               BUSY    = 1'b0;
               MUX_SEL = 4'b0;
               SER_EN  = 1'b0;
              end
             
  START_ST:   begin
               BUSY    = 1'b1;
               SER_EN  = 1'b1;
               MUX_SEL = 4'b0001;
              end
             
  DATA_ST:    begin
               BUSY     = 1'b1;
               MUX_SEL  = 4'b0010;
               if(SER_DONE)
                SER_EN = 1'b0;
              else
                SER_EN = 1'b1;	
              end
             
  PARITY_ST:  begin
               BUSY    = 1'b1;
               MUX_SEL = 4'b0011;
               SER_EN  = 1'b0;
              end
             
  STOP_ST:    begin
               MUX_SEL = 4'b0100;
               BUSY    = 1'b0;
               SER_EN  = 1'b0;
              end
 
  default :   begin
                BUSY    = 1'b0;
                MUX_SEL = 4'b0;
                SER_EN  = 1'b0;
              end
                	 
  endcase
end	
 
endmodule
 
