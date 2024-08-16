module ALU_Design  #( parameter OPER_WIDTH = 8,
                        OUT_WIDTH = OPER_WIDTH*2
)(
  input wire [OPER_WIDTH-1:0]     A,B,
  input wire [3:0]      ALU_FUN,
  input wire            CLK,
  output reg [OUT_WIDTH-1:0]     ALU_OUT,
  input wire            EN, RST,
  //output reg            Arith_flag, Logic_flag,
  //output reg            CMP_flag, Shift_flag,
  output reg                  OUT_VALID   );
  //internal_signals  
  reg [OUT_WIDTH-1:0] ALU_OUT_Comb;
  reg                 OUT_VALID_Comb;
  
  
always @(posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    ALU_OUT   <= 'b0 ;
    OUT_VALID <= 1'b0 ;	
   end
  else 
   begin  
    ALU_OUT   <= ALU_OUT_Comb ;
    OUT_VALID <= OUT_VALID_Comb ;
   end	
 end  

  always@(*)
    begin
   if(EN)
    begin  
      case(ALU_FUN)
        4'b0000: ALU_OUT_Comb =   A + B;
        4'b0001: ALU_OUT_Comb =   A - B;
        4'b0010: ALU_OUT_Comb =   A * B;
        4'b0011: ALU_OUT_Comb =   A / B;
        4'b0100: ALU_OUT_Comb =   A & B;
        4'b0101: ALU_OUT_Comb =   A | B;
        4'b0110: ALU_OUT_Comb = ~(A & B);
        4'b0111: ALU_OUT_Comb = ~(A | B);
        4'b1000: ALU_OUT_Comb =   A ^ B;
        4'b1001: ALU_OUT_Comb =  (A ~^ B);
        4'b1010: begin
                  if(A == B)
                    ALU_OUT_Comb = 16'b1;
                  else
                   ALU_OUT_Comb = 16'b0;
                 end         
        4'b1011: begin
                  if(A > B)
                    ALU_OUT_Comb = 16'b10;
                  else
                   ALU_OUT_Comb = 16'b0;
                 end
        4'b1100: begin
                   if(A < B)
                    ALU_OUT_Comb = 16'b11;
                   else
                     ALU_OUT_Comb = 16'b0;
                 end                
        4'b1101:  ALU_OUT_Comb = A >> 1; 
        4'b1110:  ALU_OUT_Comb = A << 1; 
        default:  ALU_OUT_Comb = 16'b0;
      endcase
          OUT_VALID_Comb = 1'b1;
    end
     else
   begin
	     OUT_VALID_Comb = 1'b0 ;
	      ALU_OUT_Comb   = 'b0 ;
	     
   end   
    end
    
 /* always @(*)
    begin
      if(ALU_FUN==4'b0 || ALU_FUN==4'b1 || ALU_FUN==4'b0010 || ALU_FUN==4'b0011 )
        Arith_flag = 1'b1 ;
      else
        Arith_flag = 1'b0;
     
      if(ALU_FUN==4'b0100 || ALU_FUN==4'b0101 || ALU_FUN==4'b0110 || ALU_FUN==4'b0111 || ALU_FUN== 4'b1000 || ALU_FUN==4'b1001)
        Logic_flag = 1'b1;
      else
        Logic_flag = 1'b0;
        
      if(ALU_FUN==4'b1010 || ALU_FUN==4'b1011 || ALU_FUN==4'b1100)
        CMP_flag = 1'b1;
      else
        CMP_flag = 1'b0;
        
      if(ALU_FUN==4'b1101 || ALU_FUN==4'b1110)
       Shift_flag=1'b1;
      else
        Shift_flag=1'b0;
  end*/

endmodule
     
    

                  
        
                  
                  
