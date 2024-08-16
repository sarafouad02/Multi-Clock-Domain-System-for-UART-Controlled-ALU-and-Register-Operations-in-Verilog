module DATA_SYNC #(
  parameter BUS_WIDTH = 8,
  parameter NUM_STAGES = 2 )
  (
  input                         CLK,
  input      [BUS_WIDTH-1:0]    unsync_bus,
  input                         bus_enable,RST,
  output reg [BUS_WIDTH-1:0]    sync_bus_delayed,
  output reg                    enable_pulse  );
  
  
//internal connections
reg   [NUM_STAGES-1:0]    stage_reg;
reg                       stage_out ;
					 
wire                      enable_pulse_comb ;

wire  [BUS_WIDTH-1:0]     sync_bus_comb ;
					 
// Multi flop synchronizer stage

always @(posedge CLK or negedge RST)
 begin
  if(!RST)      // active low
   begin
    stage_reg <= 'b0 ;
   end
  else
   begin
    stage_reg <= {stage_reg[NUM_STAGES-2:0],bus_enable};
   end  
 end

//pulse generator stage
always @(posedge CLK or negedge RST)
 begin
  if(!RST)      // active low
   begin
    enable_pulse <= 'b0 ;
   end
  else
   begin
    enable_pulse <= enable_pulse_comb;
   end  
 end

assign enable_pulse_comb = stage_reg[NUM_STAGES-1] && !stage_out;

always@ (posedge CLK or negedge RST)
  begin
    if(!RST)
        stage_out<='b0;
      else
        stage_out<=stage_reg[NUM_STAGES-1];
      end
      

assign sync_bus_comb = enable_pulse_comb? unsync_bus: sync_bus_delayed;

always @(posedge CLK or negedge RST)
 begin
  if(!RST)      // active low
   begin
    sync_bus_delayed <= 'b0 ;	
   end
  else
   begin
    sync_bus_delayed <= sync_bus_comb ;
   end  
 end
      
 endmodule     
      
        
  
  
  
