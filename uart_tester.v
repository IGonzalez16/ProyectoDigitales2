module uart_tester(
    input wire parity_error,     // Error de paridad
    input wire tx,              // Línea de transmisión serial
    input wire [7:0] data_out,  // Datos enviados por el receptor
    output reg clk,             // Reloj del sistema
    output reg clk_uart,        // Reloj del protocolo
    output reg rx,              // Línea de recepción serial
    output reg [7:0] data_in   // Datos enviados por el transmisor    
);

    // Generar relojes
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Periodo de 20 unidades de tiempo
    end

    initial begin
        clk_uart = 0;
        forever #5 clk_uart = ~clk_uart; // Periodo de 10 unidades de tiempo
    end

    // Secuencia de prueba
    initial begin
        tx = 0;

        data_in = 0;
        #10;
        data_in = 0;
        #10;
        data_in = 0;
        #10;
        data_in = 1;
        #10;
        data_in = 1;
        #10;
        data_in = 0;
        #10;
        data_in = 0;
        #10;
        data_in = 0;

        #20;

        rx = 0;
        data_out = 8'b00011000;


        // Esperar resultados
        #200;

        $finish;
    end

endmodule