module UART_tester(
    output reg clk,
    output reg rst,
    output reg idle_bit,
    output reg start_bit,
    output reg [7:0] tx1,
    output reg parity_bit,
    output reg stop_bit,
    input wire serial_out
);

    always begin
        #5 clk = ~clk; 
    end

    initial begin
        clk = 1;
        rst = 1;
        idle_bit = 1;
        start_bit = 1;
        tx1 = 8'b00000000;
        parity_bit = 0;
        stop_bit = 1;

        #10 rst = 0;

        #10 idle_bit = 0; 
        #10 start_bit = 0; 
        #10 start_bit = 1; tx1 = 8'b10101100; 
        #80 parity_bit = 1; tx1 = 8'b0; 
        #10 stop_bit = 1; parity_bit = 0;
        #10 idle_bit = 1; 
        #200 $finish;
    end

endmodule