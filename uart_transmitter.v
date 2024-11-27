module uart_transmitter (
    input wire clk,               // Reloj del sistema
    input wire clk_uart,          // Reloj del protocolo (la mitad del clk del sistema)
    input wire start_transmission, // Señal de inicio
    input wire [7:0] data_in,     // Datos de entrada paralelos (8 bits)
    output reg tx,                // Línea de transmisión serial
    output reg busy               // Estado del transmisor
);

    reg [3:0] state;
    reg [7:0] data_buffer;
    reg parity_bit;
    reg [3:0] bit_count;

    parameter IDLE = 0;
    parameter START_BIT = 1;
    parameter DATA_BITS = 2;
    parameter PARITY_BIT = 3;
    parameter STOP_BIT = 4;

    // Calcular paridad par
    always @(*) begin
        parity_bit = ~(^data_in); // XOR de los bits de data_in para paridad par
    end

    always @(posedge clk_uart) begin
        case (state)
            IDLE: begin
                tx <= 1'b1; // Línea en estado IDLE (alto)
                busy <= 1'b0;
                if (start_transmission) begin
                    data_buffer <= data_in;
                    state <= START_BIT;
                    busy <= 1'b1;
                end
            end

            START_BIT: begin
                tx <= 1'b0; // Bit de inicio
                state <= DATA_BITS;
                bit_count <= 0;
            end

            DATA_BITS: begin
                tx <= data_buffer[bit_count]; // Transmitir bits uno por uno
                bit_count <= bit_count + 1;
                if (bit_count == 7) begin
                    state <= PARITY_BIT; // Pasar al bit de paridad después del último bit de datos
                end
            end

            PARITY_BIT: begin
                tx <= parity_bit; // Transmitir bit de paridad
                state <= STOP_BIT;
            end

            STOP_BIT: begin
                tx <= 1'b1; // Bit de parada
                state <= IDLE;
                busy <= 1'b0; // Liberar el transmisor
            end

            default: state <= IDLE;
        endcase
    end
endmodule