`include "UART1_dut.v"
`include "UART1_tester.v"

module UART1_tb;

    wire clk_uart;
    wire clk_sis;
    wire rst;
    wire load;
    wire start_bit;
    wire [7:0] data_in;
    wire stop_bit;
    wire tx1;

    UART1_dut dut (
        .clk_uart(clk_uart),
        .clk_sis(clk_sis),
        .rst(rst),
        .start_bit(start_bit),
        .data_in(data_in),
        .stop_bit(stop_bit),
        .tx1(tx1)
    );

    UART1_tester tester (
        .clk_uart(clk_uart),
        .clk_sis(clk_sis),
        .rst(rst),
        .start_bit(start_bit),
        .data_in(data_in),
        .stop_bit(stop_bit),
        .tx1(tx1)
    );

    initial begin
        $dumpfile("UART1_tb.vcd");
        $dumpvars(0, UART1_tb);
    end

endmodule