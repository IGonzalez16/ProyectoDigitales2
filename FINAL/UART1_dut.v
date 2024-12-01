module UART1_dut(
    input wire clk,
    input wire rst,
    input wire idle_bit,
    input wire start_bit,
    input wire [7:0] tx1,
    input wire stop_bit,
    output reg serial_out
);

    localparam IDLE = 3'b000,
               START = 3'b001,
               DATA = 3'b010,
               PARITY = 3'b011,
               STOP = 3'b100;

    reg [2:0] state, next_state;
    reg [7:0] data_register; 
    reg [3:0] contador;   
    reg parity_bit;    
    reg temp_parity_bit; // Registro auxiliar para la paridad

    // Estado actual y lógica secuencial
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            serial_out <= 1'b0;
            data_register <= 8'b0;
            contador <= 4'b0;
            parity_bit <= 1'b0;
            temp_parity_bit <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: serial_out <= 1'b1; 
                START: serial_out <= 1'b0; 
                DATA: begin
                    serial_out <= data_register[0]; // BMS primero 
                    data_register <= {1'b0, data_register[7:1]}; // Shift right
                end
                PARITY: serial_out <= parity_bit;
                STOP: serial_out <= 1'b1; 
            endcase
        end
    end

    // Lógica combinacional de transición de estados
    always @(*) begin
        next_state = state;

        case (state)
            IDLE: if (!idle_bit) next_state = START;
            START: if (!start_bit || !idle_bit) next_state = DATA;
            DATA: if (contador == 8) next_state = PARITY;
            PARITY: next_state = STOP;
            STOP: next_state = IDLE;
        endcase
    end

    // Cálculo de paridad
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temp_parity_bit <= 1'b0;
        end else if (state == DATA && contador == 0) begin
            temp_parity_bit <= ^tx1;
        end
    end

    // Activación de parity_bit en el estado PARITY
    always @(*) begin
        if (state == PARITY) begin
            parity_bit = temp_parity_bit; 
        end else begin
            parity_bit = 1'b0; 
        end
    end

    // Contador para DATA
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            contador <= 4'b0;
        end else if (state == DATA) begin
            if (contador < 8) contador <= contador + 1;
        end else begin
            contador <= 4'b0;
        end
    end

endmodule