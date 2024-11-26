module uart_receiver(
    input wire clk,   //Reloj del sistema
    input wire rx,    // Linea de recepcion serial
    output reg [7:0] data_out,  //Datos de sailida paralelos
    output reg data_ready,  //Señal de datos disponibles
    output reg parity_error // Señal de error de paridad
);


    //Divisor de reloj 
    reg clk_uart;   //Reloj del protocolo
    reg [1:0] clk_div_counter;   // Contador para dividir el reloj

    always @(posedge clk) begin
        clk_div_counter <= clk_div_counter + 1;
        clk_uart <= (clk_div_counter == 2'b10); //Generar clk_uart con mitad de frecuencia 
    end

    // Estados del receptor 
    reg [3:0] state;
    reg [7:0] data_buffer;
    reg [3:0] bit_count;
    reg parity_bit;
    reg parity_calc;

    parameter IDLE = 0;
    parameter START_BIT = 1;
    parameter DATA_BITS = 2;
    parameter PARITY_BIT = 3;
    parameter STOP_BIT = 4;


    //Màquina de estados sincronizada con clk_uart
    always @(posedge clk_uart) begin
        case (state)
            IDLE: begin
                data_ready <=0;
                parity_error <=0;
                if (!rx) begin // Detectar bit de inicio (linea baja)
                    state <= START_BIT;
                    bit_count <= 0;
                end
            end

            START_BIT: begin
                //Suponer que el reloj esta sincronizado al medio dle bit
                state <= DATA_BITS;
            end

            DATA_BITS: begin
                data_buffer[bit_count] <= rx; //Leer bit entrante
                bit_count <= bit_count + 1;
                if(bit_count == 7) begin
                    state <= PARITY_BIT;
                end
            end

            PARITY_BIT: begin
                parity_bit <= rx; // Leer bit de paridad
                parity_calc <= ~(^data_buffer); //Calcular paridad
                if (parity_bit !=parity_calc) begin
                    parity_error <= 1; // Error de paridad detectado
                end
                state <= STOP_BIT;
            end

            STOP_BIT:begin
                if (rx) begin //Verificar bit de parada (linea alta)
                    data_out <= data_buffer;
                    data_ready <=1; //Datos listos
                end
                state <= IDLE;
            end

            default: state <= IDLE;

        endcase
    end
endmodule

