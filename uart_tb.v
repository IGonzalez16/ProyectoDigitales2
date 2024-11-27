`include "uart_transmissor.v"
`include "uart_receiver.v"
`include "uart_tester.v"

module uart_tb;

    wire clk;
    wire clk_uart;
    wire tx;
    wire rx;
    wire [7:0] data_in; 
    wire [7:0] data_out;
    wire parity_error;
    wire start_transmission;
    wire busy;

    uart_transmitter DUT1(
        .clk(clk),
        .clk_uart(clk_uart),
        .start_transmission(start_transmission),
        .data_in(data_in),
        .tx(tx),
        .busy(busy)
    );

    uart_receiver DUT2(
        .clk(clk),
        .clk_uart(clk_uart),
        .rx(rx),
        .data_out(data_out),
        .data_ready(data_ready),
        .parity_error(parity_error)
    );

    uart_tester tester(
        .clk(clk),
        .clk_uart(clk_uart),
        .tx(tx),
        .rx(rx),
        .data_in(data_in),
        .data_out(data_out),
        .parity_error(parity_error)
    );

    // Configuración para simulación
    initial begin
        $dumpfile("uart.vcd");
        $dumpvars(0, uart_tb);
    end

endmodule