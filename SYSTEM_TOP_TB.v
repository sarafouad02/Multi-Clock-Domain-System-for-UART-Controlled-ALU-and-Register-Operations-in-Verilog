`timescale 1ns/1ps

module SYSTEM_TOP_TB;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter ADDR_SIZE  = 4;
    
    // DUT Ports
    reg REF_CLK;
    reg RST;
    reg UART_CLK;
    reg RX_IN;
    wire TX_OUT;
    wire parity_error, framing_error;
    
    // Instantiate the DUT (Device Under Test)
    SYSTEM_TOP #(.DATA_WIDTH(DATA_WIDTH), .ADDR_SIZE(ADDR_SIZE) ) DUT (
        .REF_CLK(REF_CLK),
        .RST(RST),
        .UART_CLK(UART_CLK),
        .RX_IN(RX_IN),
        .TX_OUT(TX_OUT),
        .parity_error(parity_error),
        .framing_error(framing_error)
    );
    
    parameter UART_PERIOD = 271.26;
    parameter REF_PERIOD  =20;

    // Clock Generation
    initial begin
        
        forever #10 REF_CLK = ~REF_CLK;  // 50 MHz clock (20 ns period)
    end

    initial begin
       
        forever #135.63 UART_CLK = ~UART_CLK;  // 3.6864 MHz clock (271.6 ns period)
    end
    
    
   

    // Task to send a byte serially via RX_IN
    task send_byte(input [7:0] data ,input parity);
    integer i;
    begin
   
       // Start bit
        RX_IN = 1'b0;
        
        #(UART_PERIOD*32);

        // Sending each bit of the byte
        for (i = 0; i < 8; i = i + 1) begin
            RX_IN = data[i];
            #(UART_PERIOD*32);
        end
        // parity bit
          RX_IN=parity;
          #(UART_PERIOD*32); 
        // Stop bit
        RX_IN = 1'b1;
        #(UART_PERIOD*32);
        
    end
    endtask

    // Task for Register File Write Command
    task reg_file_write(input [3:0] addr, input [7:0] data,input parity_addr , input parity_data);
    begin
        send_byte(8'hAA, 1'b0);
        #(12*33*UART_PERIOD) // Register File Write Command
        send_byte({4'b0000, addr}, parity_addr);
        #(12*33*UART_PERIOD) // Address
        send_byte(data, parity_data); // Data
        #(12*33*UART_PERIOD);
    end
    endtask

    // Task for Register File Read Command
    task reg_file_read(input [3:0] addr, parity_addr);
    begin
        send_byte(8'hBB,1'b0); 
         #(12*33*UART_PERIOD);// Register File Read Command
        send_byte({4'b0000, addr}, parity_addr); // Address
         #(12*33*UART_PERIOD);
    end
    endtask

    // Task for ALU Operation with Operand
    task alu_op_with_operand(input [3:0] alu_fun, input [7:0] operand_a, input [7:0] operand_b, input parity_a, input parity_b, input alu_fun_parity);
    begin
        send_byte(8'hCC,1'b0);
        #(12*33*UART_PERIOD); // ALU Operation Command with Operand
        send_byte(operand_a, parity_a);
         #(12*33*UART_PERIOD); // Operand A
        send_byte(operand_b, parity_b);
         #(12*33*UART_PERIOD); // Operand B
        send_byte({4'b0000, alu_fun}, alu_fun_parity); // ALU Function
         #(12*33*UART_PERIOD);
    end
    endtask

    // Task for ALU Operation without Operand
    task alu_op_without_operand(input [3:0] alu_fun , input alu_fun_parity);
    begin
        send_byte(8'hDD,1'b0);
        #(12*33*UART_PERIOD);// ALU Operation Command without Operand
        send_byte({4'b0000, alu_fun}, alu_fun_parity); // ALU Function
        #(12*33*UART_PERIOD);
    end
    endtask
task reset ;
 begin
  RST =  'b1;
  #(REF_CLK);
  RST  = 'b0;
  #(REF_CLK);
  RST  = 'b1;
 end
 endtask
    // Test sequence
    initial begin
      REF_CLK = 0;
       UART_CLK = 0;
       
        reset();
        #100;
        // Test: Write to Register File
        reg_file_write(4'd4, 8'h3c, 1'b1, 1'b0); 
      
       #(12*32*UART_PERIOD); 
  

      // Test: Read from Register File
      reg_file_read(4'd4,1'b1);         
         
      #(12*32*UART_PERIOD); 
        // Test: ALU Operation with Operand
       alu_op_with_operand(4'd0, 8'hF0, 8'h0F, 1'b0 , 1'b0, 1'b0);
  
        #(12*32*UART_PERIOD);
        
        // Test: ALU Operation without Operand
        alu_op_without_operand(4'd1 , 1'b1); 
        
        #(12*32*UART_PERIOD); 
        #(12*32*UART_PERIOD);
        
       // 
 alu_op_with_operand(4'd2, 8'd15,8'd45, 1'b0 , 1'b0, 1'b1);
        
 
        
 
      //
  #(12*32*UART_PERIOD); 
        #(12*32*UART_PERIOD);
        
       // #(REF_CLK); 
        // ALU Function 2 
        

        // Add more test cases to cover other system components...

      //  #60000; // Wait for all operations to complete
        $stop;
    end

    // Monitor output
   /* initial begin
        $monitor("Time=%0t | RX_IN=%b | TX_OUT=%b | ALU_OUT=%h | OUT_Valid=%b", $time, RX_IN, TX_OUT, ALU_OUT, OUT_Valid);
    end*/

endmodule
