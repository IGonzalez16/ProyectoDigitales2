module uart_receiver(
    input wire clk,               // Reloj del sistema
    input wire clk_uart,          // Reloj del protocolo (la mitad del clk del sistema)
    output reg [7:0] data_out,    // Datos de salida paralelos (8 bits)
    output reg data_ready,        // Señal de datos disponibles
    input wire tx2,               // Línea de transmisión serial hacia rx1
    output reg rx2                // Linea de recibir datos desde tx1 
);

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

    // Máquina de estados sincronizada con clk_uart
    always @(posedge clk_uart) begin
        case (state)
            IDLE: begin
                data_ready <= 0;
                parity_error <= 0;
                if (!rx) begin // Detectar bit de inicio (línea baja)
                    state <= START_BIT;
                    bit_count <= 0;
                end
            end

            START_BIT: begin
                // Suponer que el reloj está sincronizado al medio del bit
                state <= DATA_BITS;
            end

            DATA_BITS: begin
                data_buffer[bit_count] <= rx; // Leer bit entrante
                bit_count <= bit_count + 1;
                if (bit_count == 7) begin
                    state <= PARITY_BIT; // Pasar al bit de paridad después del último bit de datos
                end
            end

            PARITY_BIT: begin
                parity_bit <= rx; // Leer bit de paridad
                parity_calc <= ~(^data_buffer); // Calcular paridad esperada
                if (parity_bit != parity_calc) begin
                    parity_error <= 1; // Error de paridad detectado
                end
                state <= STOP_BIT;
            end

            STOP_BIT: begin
                if (rx) begin // Verificar bit de parada (línea alta)
                    data_out <= data_buffer;
                    data_ready <= 1; // Señalar datos listos
                end
                state <= IDLE;
            end

            default: state <= IDLE;

        endcase
    end
endmodule
