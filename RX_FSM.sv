module UART_RX_FSM #(parameter WIDTH=8)(
  
  input  wire                   RX_IN, PAR_EN, RST, 
  input  wire                   par_err, strt_glitch,stp_err,
  input  wire    [3:0]          bit_cnt, 
  input  wire    [5:0]          edge_cnt, 
  input  wire    [5:0]          prescale,
  input  wire                   CLK ,
  output reg                    par_chk_en, strt_chk_en, stp_chk_en, data_valid,deser_en,
  output reg                    dat_samp_en, enable
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
 
  
always @(*)
 begin
    deser_en=1'b0;
	next_state = IDLE;
  case(current_state)
  IDLE:    begin

            if (RX_IN == 0 && !strt_glitch)
                next_state = START_ST;
            else
                next_state = IDLE;
           end
             
  START_ST:   begin

               if(bit_cnt == 1 && edge_cnt == prescale-1) 
                 begin
                   deser_en=1'b0;
                	if(strt_glitch)
                     next_state = IDLE;
                   else
                     next_state = DATA_ST;
                end
             end
             
  DATA_ST:    begin
                 deser_en=1'b1;
              if (bit_cnt == 9 && edge_cnt == prescale-1)
                begin
                  
                  if(PAR_EN)
                    next_state=PARITY_ST;
                  else
                    begin
                      next_state=STOP_ST;
                      deser_en=1'b0;
                    end
                end
              else
               next_state=current_state;
              end
             
  PARITY_ST:  begin
         
                if (bit_cnt == 10 && edge_cnt == prescale-1)
                  begin
                    deser_en=1'b0;
                    next_state = STOP_ST;
                  end
                else 
                    next_state = current_state;
                  
              end
             
  STOP_ST:    begin
              if(bit_cnt==10 && edge_cnt==prescale-1 && !PAR_EN )
                begin
                  deser_en=1'b0;
                  if(!RX_IN)
                   next_state = START_ST;
                 else
                   next_state = IDLE;
              end
            else if(bit_cnt ==11 && edge_cnt== prescale-1 && PAR_EN )
              begin
                deser_en=1'b0;
                   next_state= IDLE;
              end
            end
            
 
  default : begin
                next_state= IDLE;
                deser_en=1'b0;
              end
  
  endcase
end	

 always @(*)
 begin
	      data_valid = 1'b0;
              par_chk_en =1'b0;
              strt_chk_en=1'b0;
              stp_chk_en=1'b0;
              enable=1'b0;
              dat_samp_en=1'b1;
  case(current_state)
  IDLE:      begin
              data_valid = 1'b0;
              par_chk_en =1'b0;
              strt_chk_en=1'b0;
              stp_chk_en=1'b0;
              enable=1'b0;
              dat_samp_en=1'b1;
             end
             
  START_ST:   begin
               strt_chk_en=1'b1;
               enable=1'b1;
               dat_samp_en=1'b1;
               par_chk_en=1'b0;
               stp_chk_en=1'b0;
              end
             
  DATA_ST:    begin
               dat_samp_en=1'b1;
               strt_chk_en=1'b0; 
               par_chk_en=1'b0;
               enable=1'b1;
               
              end
             
  PARITY_ST:  begin
                par_chk_en=1'b1;
                dat_samp_en=1'b1;
                strt_chk_en=1'b0;
  
                enable=1'b1;
              end
             
  STOP_ST:    begin
               dat_samp_en = 1'b1;
               stp_chk_en  = 1'b1;
               par_chk_en  = 1'b0;
               strt_chk_en = 1'b0;
               enable      = 1'b1;
        
               if(!par_err && !stp_err && RX_IN==1)
                  data_valid=1'b1;
                if(par_err ||stp_err)
                 begin
                  enable = 1'b0;
                  data_valid = 1'b0;
                end
              end
 
  default :   begin
               data_valid = 1'b0;
               par_chk_en =1'b0;
               strt_chk_en=1'b0;
               stp_chk_en=1'b0;
               enable=1'b0;
               dat_samp_en=1'b1;
              end
                	 
  endcase
end	
 
endmodule

