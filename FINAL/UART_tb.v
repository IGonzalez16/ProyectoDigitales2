`include "UART1_dut.v"
`include "UART_tester.v"
//`include "UART2_dut.v"

module UART_tb;

    wire clk_uart;
    wire clk_sis;
    wire rst;
    wire load;
    wire start_bit;
    wire [7:0] data_in;
    wire stop_bit;
    wire tx1;
    wire rx2;

    UART1_dut dut (
        .clk_uart(clk_uart),
        .clk_sis(clk_sis),
        .rst(rst),
        .start_bit(start_bit),
        .data_in(data_in),
        .stop_bit(stop_bit),
        .tx1(tx1)
        //.rx2(pepe)
    );

    UART_tester tester (
        .clk_uart(clk_uart),
        .clk_sis(clk_sis),
        .rst(rst),
        .start_bit(start_bit),
        .data_in(data_in),
        .stop_bit(stop_bit),
        .tx1(tx1)
    );

    initial begin
        $dumpfile("UART_tb.vcd");
        $dumpvars(0, UART_tb);
    end

endmodule