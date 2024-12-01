`include "UART1_dut.v"
`include "UART1_tester.v"

module UART1_tb;

    wire clk;
    wire rst;
    wire load;
    // wire idle_bit;
    wire start_bit;
    wire [7:0] data_in;
    wire stop_bit;
    wire tx1;
    wire parallel_in_active;

    UART1_dut dut (
        .clk(clk),
        .rst(rst),
        // .idle_bit(idle_bit),
        .start_bit(start_bit),
        .data_in(data_in),
        .stop_bit(stop_bit),
        .tx1(tx1),
        .load(load),
        .parallel_in_active(parallel_in_active)
    );

    UART1_tester tester (
        .clk(clk),
        .rst(rst),
        // .idle_bit(idle_bit),
        .start_bit(start_bit),
        .data_in(data_in),
        .stop_bit(stop_bit),
        .tx1(tx1),
        .load(load),
        .parallel_in_active(parallel_in_active)
    );

    initial begin
        $dumpfile("UART1_tb.vcd");
        $dumpvars(0, UART1_tb);
    end

endmodule