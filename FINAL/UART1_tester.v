module UART1_tester(
    output reg clk,
    output reg rst,
    output reg idle_bit,
    output reg start_bit,
    output reg [7:0] tx1,
    output reg stop_bit,
    output reg load,
    input wire serial_out,
    input wire parallel_in_active
);

    always begin
        #5 clk = ~clk; 
    end

    initial begin
        clk = 1;
        rst = 1;
        load = 0;
        idle_bit = 1;
        start_bit = 1;
        tx1 = 8'b00000000;
        stop_bit = 0;

        #10 rst = 0;

        #10 idle_bit = 0; 
        start_bit = 0; 
        #10 start_bit = 1; load = 1; tx1 = 8'b10111010; 
        #10 load = 0; #80 tx1 = 8'b0; 
        #10 stop_bit = 1; 
        #10 idle_bit = 1; stop_bit = 0; 
        #200 $finish;
    end

endmodule