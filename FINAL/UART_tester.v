module UART_tester(
    output reg clk_sis,
    output reg clk_uart,
    output reg rst,
    output reg start_bit,
    output reg [7:0] data_in_1,
    output reg [7:0] data_in_2,
    output reg stop_bit
);

    always begin
        #2.5 clk_sis = ~clk_sis;
    end

    always begin
        #5 clk_uart = ~clk_uart; 
    end

    initial begin
        clk_sis = 1;
        clk_uart = 1;
        //UART1 -> UART2
        rst = 1;
        start_bit = 1;
        data_in_1 = 8'b00000000;
        data_in_2 = 8'b00000000; 
        stop_bit = 0;

        #10 rst = 0;

        start_bit = 0; 
        #10 start_bit = 1; data_in_1 = 8'b01011011; 
        #90 data_in_1 = 8'b0; 
        stop_bit = 1;
        #10 stop_bit = 0; 
        #10 rst = 1;


        //UART2 -> UART1
        #10 rst = 1;
        start_bit = 1;
        stop_bit = 0;

        #10 rst = 0;

        start_bit = 0; 
        #10 start_bit = 1; data_in_2 = 8'b01000010; 
        #90 data_in_2 = 8'b0; 
        stop_bit = 1;
        #10 stop_bit = 0; 
        #10 rst = 1;
  
        #10;
        
        $finish;
        
    end

endmodule