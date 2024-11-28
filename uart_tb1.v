`include "uart1.v"
`include "uart2.v"
`include "uart_tester1.v"

module uart_tb1;

    // Señales globales
    wire clk;
    wire clk_uart;
    wire reset;

    // Señales UART1
    wire start_tx1;
    wire [7:0] data_in1;
    wire [7:0] data_out1;
    wire data_ready1;

    // Señales UART2
    wire start_tx2;
    wire [7:0] data_in2;
    wire [7:0] data_out2;
    wire data_ready2;

    // Interconexiones
    wire tx1, tx2;

    // Instancias de los módulos UART
    uart1 uart1_inst (
        .clk(clk),
        .clk_uart(clk_uart),
        .reset(reset),
        .start_transmission(start_tx1),
        .data_in(data_in1),
        .rx(tx2), // Recibe desde UART2
        .tx(tx1), // Transmite hacia UART2
        .data_out(data_out1),
        .data_ready(data_ready1),
        .busy() // No se usa en este testbench
    );

    uart2 uart2_inst (
        .clk(clk),
        .clk_uart(clk_uart),
        .reset(reset),
        .start_transmission(start_tx2),
        .data_in(data_in2),
        .rx(tx1), // Recibe desde UART1
        .tx(tx2), // Transmite hacia UART1
        .data_out(data_out2),
        .data_ready(data_ready2),
        .busy() // No se usa en este testbench
    );

    // Instancia del tester
    uart_tester tester (
        .clk(clk),
        .clk_uart(clk_uart),
        .reset(reset),
        .start_tx1(start_tx1),
        .data_in1(data_in1),
        .data_out1(data_out1),
        .data_ready1(data_ready1),
        .start_tx2(start_tx2),
        .data_in2(data_in2),
        .data_out2(data_out2),
        .data_ready2(data_ready2),
        .tx1(tx1),
        .tx2(tx2)
    );

    // Configuración de la simulación
    initial begin
        $dumpfile("uart.vcd");  // Archivo de salida para simulación
        $dumpvars(0, uart_tb1);  // Variables a registrar
    end

endmodule
