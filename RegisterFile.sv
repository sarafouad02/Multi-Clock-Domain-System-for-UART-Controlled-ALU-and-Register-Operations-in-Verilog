
module RegFile #(parameter WIDTH = 8, DEPTH = 16, ADDR = 4 )
  (
  input wire [ADDR-1:0]  Address,
  input wire [WIDTH-1:0] WrData,
  input wire        WrEn,
  input wire        RdEn,
  input wire        CLK,
  input wire        RST,
  output reg [WIDTH-1:0] RdData,
  output   reg                 RdData_VLD,
  output   wire   [WIDTH-1:0]  REG0,
  output   wire   [WIDTH-1:0]  REG1,
  output   wire   [WIDTH-1:0]  REG2,
  output   wire   [WIDTH-1:0]  REG3 );
  
  reg [15:0] Registers [0:7];
  reg [5:0] i;
  always@ (posedge CLK or negedge RST)
    begin
      if(!RST)
       begin
         RdData_VLD <= 1'b0 ;
	     RdData     <= 'b0 ;
      for (i=0 ; i < DEPTH ; i = i +1)
        begin
		 if(i==2)
          Registers[i] <= 'b100000_01 ;
		 else if (i==3) 
          Registers[i] <= 'b0010_0000 ;
         else
          Registers[i] <= 'b0 ;
        end
       end
      else 
        begin
      if(WrEn)
        Registers[Address] <= WrData;
     else if(RdEn)
       begin
        RdData_VLD <= 1'b1 ;
        RdData <= Registers[Address];
      end
      else
        RdData_VLD <= 1'b0 ;
      end
    end
    
assign REG0 = Registers[0] ;
assign REG1 = Registers[1] ;
assign REG2 = Registers[2] ;
assign REG3 = Registers[3] ;

  endmodule
        
        