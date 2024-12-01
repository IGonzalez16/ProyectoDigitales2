`include "UART2_dut.v"
`include "UART2_tester.v"

module UART2_tb;

    wire clk_uart;
    wire clk_sis;
    wire rst;
    wire start_bit;
    wire [7:0] data_in;
    wire stop_bit;
    wire tx2;
    wire rx2;

    UART2_dut dut (
        .clk_sis(clk_sis),
        .clk_uart(clk_uart),
        .rst(rst),
        .start_bit(start_bit),
        .data_in(data_in),
        .stop_bit(stop_bit),
        .tx2(tx2),
        .rx2(rx2)
    );

    UART2_tester tester (
        .clk_sis(clk_sis),
        .clk_uart(clk_uart),
        .rst(rst),
        .start_bit(start_bit),
        .data_in(data_in),
        .stop_bit(stop_bit),
        .tx2(tx2),
        .rx2(rx2)
    );

    initial begin
        $dumpfile("UART2_tb.vcd");
        $dumpvars(0, UART2_tb);
    end

endmodule