`include "UART1_dut.v"
`include "UART2_dut.v"
`include "UART_tester.v"

module UART_tb;

    wire clk_uart;
    wire clk_sis;
    wire rst;
    wire start_bit;
    wire [7:0] data_in;
    wire stop_bit;
    wire tx2;
    wire rx2;
    wire serial1;
    wire serial2;

    UART1_dut dut (
        .clk_sis(clk_sis),
        .clk_uart(clk_uart),
        .rst(rst),
        .start_bit(start_bit),
        .data_in(data_in),
        .stop_bit(stop_bit),
        .tx1(serial1),
        .rx1(serial2)
    );

    UART2_dut dut (
        .clk_sis(clk_sis),
        .clk_uart(clk_uart),
        .rst(rst),
        .start_bit(start_bit),
        .data_in(data_in),
        .stop_bit(stop_bit),
        .tx2(serial2),
        .rx2(serial1)
    );

    UART_tester tester (
        .clk_sis(clk_sis),
        .clk_uart(clk_uart),
        .rst(rst),
        .start_bit(start_bit),
        .data_in(data_in),
        .stop_bit(stop_bit)
    );

    initial begin
        $dumpfile("UART_tb.vcd");
        $dumpvars(0, UART_tb);
    end

endmodule