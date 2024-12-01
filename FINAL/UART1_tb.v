`include "UART1_dut.v"
`include "UAR1_tester.v"

module UART_tb;

    wire clk;
    wire rst;
    wire [1:0] idle_bit;
    wire [1:0] start_bit;
    wire [7:0] tx1;
    wire [1:0] parity_bit;
    wire [1:0] stop_bit;
    wire serial_out;

    UART_dut dut (
        .clk(clk),
        .rst(rst),
        .idle_bit(idle_bit),
        .start_bit(start_bit),
        .tx1(tx1),
        .parity_bit(parity_bit),
        .stop_bit(stop_bit),
        .serial_out(serial_out)
    );

    UART_tester tester (
        .clk(clk),
        .rst(rst),
        .idle_bit(idle_bit),
        .start_bit(start_bit),
        .tx1(tx1),
        .parity_bit(parity_bit),
        .stop_bit(stop_bit),
        .serial_out(serial_out)
    );

    initial begin
        $dumpfile("UART1_tb.vcd");
        $dumpvars(0, UART_tb);
    end

endmodule