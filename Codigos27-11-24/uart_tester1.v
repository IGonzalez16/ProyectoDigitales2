`timescale 1ns/1ps

module uart_tester (
    output reg clk,
    output reg clk_uart,
    output reg reset,
    output reg start_tx1,
    output reg [7:0] data_in1,
    input wire [7:0] data_out1,
    input wire data_ready1,
    output reg start_tx2,
    output reg [7:0] data_in2,
    input wire [7:0] data_out2,
    input wire data_ready2,
    input wire tx1,
    input wire tx2
);


    // Generador de reloj del sistema
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Periodo de 10 ns
    end

    // Generador de reloj del protocolo UART
    initial begin
        clk_uart = 0;
        forever #20 clk_uart = ~clk_uart; // Periodo de 40 ns
    end

    // Estímulos de prueba
    initial begin
        // Inicialización
        reset = 1;
        start_tx1 = 0;
        start_tx2 = 0;
        data_in1 = 8'h00;
        data_in2 = 8'h00;

        #50 reset = 0; // Desactivar reset

        // Prueba 1: UART1 transmite a UART2
        data_in1 = 8'hA5; // Dato a transmitir (10100101)
        start_tx1 = 1;    // Iniciar transmisión
        #40 start_tx1 = 0;

        // Esperar a que UART2 reciba el dato

        // Aplicar reset
        #50 reset = 1;
        #50 reset = 0;

        // Prueba 2: UART2 transmite a UART1
        data_in2 = 8'h3C; // Dato a transmitir (00111100)
        start_tx2 = 1;    // Iniciar transmisión
        #40 start_tx2 = 0;

        // Esperar a que UART1 reciba el dato

        // Finalización de la simulación
        #100 $finish;
    end


endmodule
