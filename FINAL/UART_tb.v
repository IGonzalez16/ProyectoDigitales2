`include "UART_dut.v"
`include "UART_tester.v"

module UART_tb;

    wire clk_uart;
    wire clk_sis;
    wire rst;
    wire start_bit;
    wire [7:0] data_in_1;
    wire [7:0] data_in_2;
    wire stop_bit;
    wire tx2;
    wire tx1;
    wire rx2;
    wire rx1;
    wire serial1;               // Cable de conexión entre tx1 y rx2
    wire serial2;               // Cable de conexión entre tx2 y rx1

    UART1_dut dut1 (
        .clk_sis(clk_sis),
        .clk_uart(clk_uart),
        .rst(rst),
        .start_bit(start_bit),
        .data_in_1(data_in_1),
        .stop_bit(stop_bit),
        .tx1(serial1),          // Conexión entre UARTs
        .rx1(serial2)           // Conexión entre UARTs
    );

    UART2_dut dut2 (
        .clk_sis(clk_sis),
        .clk_uart(clk_uart),
        .rst(rst),
        .start_bit(start_bit),
        .data_in_2(data_in_2),
        .stop_bit(stop_bit),
        .tx2(serial2),          // Conexión entre UARTs
        .rx2(serial1)           // Conexión entre UARTs
    );

    UART_tester tester (
        .clk_sis(clk_sis),
        .clk_uart(clk_uart),
        .rst(rst),
        .start_bit(start_bit),
        .data_in_1(data_in_1),
        .data_in_2(data_in_2),
        .stop_bit(stop_bit)
    );

    initial begin
        $dumpfile("UART_tb.vcd");
        $dumpvars(0, UART_tb);
    end

endmodule

