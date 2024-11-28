module uart1 (
    input wire clk,                // Reloj del sistema
    input wire clk_uart,           // Reloj del protocolo
    input wire reset,              // Señal de reinicio
    input wire start_transmission, // Señal para iniciar la transmisión
    input wire [7:0] data_in,      // Datos de entrada para transmitir
    input wire rx,                 // Línea de recepción (desde UART2)
    output reg tx,                 // Línea de transmisión (hacia UART2)
    output reg [7:0] data_out,     // Datos recibidos
    output reg data_ready,         // Señal que indica datos listos
    output reg busy                // Señal que indica si está transmitiendo
);

    // Variables para transmisión
    reg [3:0] tx_state, next_tx_state;
    reg [7:0] tx_buffer;
    reg tx_parity_bit;
    reg [3:0] tx_bit_count;

    // Variables para recepción
    reg [3:0] rx_state, next_rx_state;
    reg [7:0] rx_buffer;
    reg rx_parity_bit, received_parity;
    reg [3:0] rx_bit_count;

    // Estados de transmisión
    parameter TX_IDLE = 0;
    parameter TX_START_BIT = 1;
    parameter TX_DATA_BITS = 2;
    parameter TX_PARITY_BIT = 3;
    parameter TX_STOP_BIT = 4;

    // Estados de recepción
    parameter RX_IDLE = 0;
    parameter RX_START_BIT = 1;
    parameter RX_DATA_BITS = 2;
    parameter RX_PARITY_BIT = 3;
    parameter RX_STOP_BIT = 4;

    // Cálculo de paridad para transmisión
    always @(*) begin
        tx_parity_bit = ~(^tx_buffer); // Paridad par
    end

    // Máquina de estados para transmisión
    always @(posedge clk_uart or posedge reset) begin
        if (reset) begin
            tx <= 1;
            tx_state <= TX_IDLE;
            tx_bit_count <= 0;
            busy <= 0;
        end else begin
            case (tx_state)
                TX_IDLE: begin
                    tx <= 1; // Línea en alto
                    busy <= 0;
                    if (start_transmission) begin
                        tx_buffer <= data_in;
                        next_tx_state <= TX_START_BIT;
                        busy <= 1;
                    end
                end

                TX_START_BIT: begin
                    tx <= 0; // Bit de inicio
                    next_tx_state <= TX_DATA_BITS;
                    tx_bit_count <= 0;
                end

                TX_DATA_BITS: begin
                    tx <= tx_buffer[tx_bit_count]; // Enviar bits de datos
                    tx_bit_count <= tx_bit_count + 1;
                    if (tx_bit_count == 8) begin
                        next_tx_state <= TX_PARITY_BIT;
                    end
                end

                TX_PARITY_BIT: begin
                    tx <= tx_parity_bit; // Enviar bit de paridad
                    next_tx_state <= TX_STOP_BIT;
                end

                TX_STOP_BIT: begin
                    tx <= 1; // Bit de parada
                    next_tx_state <= TX_IDLE;
                    busy <= 0;
                end

                default: tx_state <= TX_IDLE;
            endcase

            tx_state <= next_tx_state; // Actualizar el estado
        end
    end

    // Máquina de estados para recepción
    always @(posedge clk_uart or posedge reset) begin
    if (reset) begin
        // Restablecer los valores
        rx_state <= RX_IDLE;
        data_out <= 0;
        data_ready <= 0;
        rx_bit_count <= 0;
    end else begin
        case (rx_state)
            RX_IDLE: begin
                data_ready <= 0;
                if (!rx) begin // Detectar bit de inicio
                    rx_state <= RX_START_BIT;
                    rx_bit_count <= 0;
                end
            end

            RX_START_BIT: begin
                rx_state <= RX_DATA_BITS;
            end

            RX_DATA_BITS: begin
                rx_buffer[rx_bit_count] <= rx; // Leer bits de datos
                rx_bit_count <= rx_bit_count + 1;
                if (rx_bit_count == 8) begin
                    rx_state <= RX_PARITY_BIT;
                end
            end

            RX_PARITY_BIT: begin
                received_parity <= rx; // Leer bit de paridad
                rx_state <= RX_STOP_BIT;
            end

            RX_STOP_BIT: begin
                if (rx == 1 && received_parity == ~(^rx_buffer)) begin // Validar paridad
                    data_out <= rx_buffer; // Guardar datos si la paridad es correcta
                    data_ready <= 1;
                end
                rx_state <= RX_IDLE;
            end

            default: rx_state <= RX_IDLE;
        endcase
    end
end

endmodule
