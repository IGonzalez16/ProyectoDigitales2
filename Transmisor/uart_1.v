module uart_1 (
    input wire clk,               // Reloj del sistema
    input wire clk_uart,          // Reloj del protocolo (la mitad del clk del sistema)
    input wire start_transmission, // Señal de inicio
    input wire [7:0] data_in,     // Datos de entrada paralelos (8 bits)
    output reg tx1                // Línea de transmisión serial
);

    // Estados para la máquina de estados
    reg [2:0] state, next_state;
    reg [10:0] data_packet;       // Paquete de datos serializados (1 start bit, 8 data bits, 1 parity, 1 stop bit)
    reg [3:0] bit_count;          // Contador para los bits transmitidos

    parameter IDLE       = 3'd0;
    parameter LOAD_DATA  = 3'd1;
    parameter START_BIT  = 3'd2;
    parameter DATA_BITS  = 3'd3;
    parameter PARITY_BIT = 3'd4;
    parameter STOP_BIT   = 3'd5;

    // Calcular paridad
    reg parity_bit;
    always @(*) begin
        if (^data_in) // XOR de todos los bits de data_in
            parity_bit = 1'b1; // Número impar de unos
        else
            parity_bit = 1'b0; // Número par de unos
    end

    // Máquina de estados para la transmisión
    always @(posedge clk_uart) begin
        if (!start_transmission) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Transición de estados
    always @(*) begin
        case (state)
            IDLE: begin
                tx1 = 1'b1; // Línea en estado IDLE (alto)
                next_state = start_transmission ? LOAD_DATA : IDLE;
            end

            LOAD_DATA: begin
                // Armar el paquete de datos: [STOP][PARITY][DATA][START]
                data_packet = {1'b1, parity_bit, data_in, 1'b0}; // STOP=1, PARITY=parity_bit, START=0
                bit_count = 0; // Inicializar el contador de bits
                next_state = START_BIT;
            end

            START_BIT: begin
                tx1 = data_packet[0]; // Enviar el bit de inicio
                next_state = DATA_BITS;
            end

            DATA_BITS: begin
                tx1 = data_packet[bit_count + 1]; // Enviar cada bit de datos
                bit_count = bit_count + 1;
                if (bit_count == 8) begin
                    next_state = PARITY_BIT; // Pasar al bit de paridad
                end else begin
                    next_state = DATA_BITS;
                end
            end

            PARITY_BIT: begin
                tx1 = data_packet[9]; // Enviar el bit de paridad
                next_state = STOP_BIT;
            end

            STOP_BIT: begin
                tx1 = data_packet[10]; // Enviar el bit de parada
                next_state = IDLE; // Volver a estado IDLE
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule
