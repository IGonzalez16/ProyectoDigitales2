module UART_tester(
    output reg clk_uart,
    output reg clk_sis,
    output reg rst,
    output reg start_bit,
    output reg [7:0] data_in,
    output reg stop_bit,
    input wire tx1
);

    // Generador de clk_uart (frecuencia base)
    always begin
        #5 clk_uart = ~clk_uart; // clk_uart cambia cada 5 unidades de tiempo
    end

    // Generador de clk_sis (doble de la frecuencia de clk_uart)
    always begin
        #2.5 clk_sis = ~clk_sis; // clk_sis cambia cada 10 unidades de tiempo
    end

    // PRUEBA UART1:
    initial begin
        // Se inicializan los valores de prueba
        clk_sis = 1;
        clk_uart = 1;
        rst = 1;
        start_bit = 1;
        data_in = 8'b00000000;
        stop_bit = 0;

        // Cambios de datos
        #10 rst = 0;
        start_bit = 0; 
        #10 start_bit = 1; data_in = 8'b01011011; 
        #90 data_in = 8'b0; 
        stop_bit = 1;
        #10 stop_bit = 0; 
        #10 rst = 1;
        #10 rst = 0;
        #200 $finish;
        
    end

endmodule