module UART2_tester(
    output reg clk_sis,
    output reg clk_uart,
    output reg rst,
    output reg start_bit,
    output reg [7:0] data_in,
    output reg stop_bit,
    output reg rx2,
    input wire tx2
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
        rst = 1;
        start_bit = 1;
        data_in = 8'b00000000;
        stop_bit = 0;

        #10 rst = 0;

        start_bit = 0; 
        #10 start_bit = 1; data_in = 8'b01011011; 
        #90 data_in = 8'b0; 
        stop_bit = 1;
        #10 stop_bit = 0; 
        #10 rst = 1;
        #10 rst = 0;
        #200 $finish;
        
    end

endmodule