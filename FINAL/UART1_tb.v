`include "UART1_dut.v"
`include "UART1_tester.v"

module UART1_tb;

    wire clk;
    wire rst;
    wire idle_bit;
    wire start_bit;
    wire [7:0] tx1;
    wire stop_bit;
    wire serial_out;

    UART1_dut dut (
        .clk(clk),
        .rst(rst),
        .idle_bit(idle_bit),
        .start_bit(start_bit),
        .tx1(tx1),
        .stop_bit(stop_bit),
        .serial_out(serial_out)
    );

    UART1_tester tester (
        .clk(clk),
        .rst(rst),
        .idle_bit(idle_bit),
        .start_bit(start_bit),
        .tx1(tx1),
        .stop_bit(stop_bit),
        .serial_out(serial_out)
    );

    initial begin
        $dumpfile("UART1_tb.vcd");
        $dumpvars(0, UART1_tb);
    end

endmodule