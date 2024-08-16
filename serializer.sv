module serializer (
  input  wire             DATA_VALID, RST, SER_EN,
  input  wire             CLK , 
  input  wire    [7:0]    P_DATA,
  output    reg              SER_DONE,
  output    reg            SER_DATA,
  input wire              BUSY
  );
  
reg [7:0] shift_register;
reg [7:0] prev_data;        // Previous data to hold the last valid data
reg [2:0] counter;
reg [2:0] i;

always @(posedge CLK or negedge RST)
 
  begin
 
    if(!RST) 
      
      begin
       SER_DATA  <= 1'b0;
       SER_DONE  <= 1'b0;
       counter   <= 0;
        prev_data <= 8'b0;
       shift_register <= 8'b0; 
       
      end
      
else if(DATA_VALID && !BUSY)
    begin
    
    if (P_DATA != prev_data) 
       
      begin                       
        shift_register <= P_DATA;
        SER_DONE <= 1'b0;
        prev_data <= P_DATA; 
      end
   else
     shift_register <= shift_register;
   end
 else if(SER_EN)
      
     begin
       SER_DATA <= shift_register[0]; //SER_DATA driven by the LSB of the shift register
       SER_DONE <= 1'b0;
  /*  for(i=3'b0; i <= 3'd7; i = i+1'b1)
    begin
      shift_register[i] <= shift_register[i+1];
    end*/
    shift_register <= {shift_register[7], shift_register[7:1]};

    
    if(counter!=3'd7)
      counter<=counter+1'b1;
  else
    SER_DONE <= 1'b1;
    
      end
      
    else
      begin
     SER_DONE <= 1'b0;
     counter  <= 3'd0;
    end
 end
endmodule 

 
