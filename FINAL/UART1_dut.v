module UART1_dut(
    input wire clk,
    input wire rst,
    input wire load,
    input wire start_bit,
    input wire [7:0] data_in,
    input wire stop_bit,
    output reg tx1,
    output reg parallel_in_active
);

    localparam IDLE = 3'b000,
               START = 3'b001,
               DATA = 3'b010,
               PARITY = 3'b011,
               STOP = 3'b100;

    reg [2:0] state, next_state;
    reg [7:0] data_register; 
    reg [3:0] contador;

    reg [7:0] shift_register; 
    reg [3:0] bit_counter;    
    reg tx1_ready, idle_bit;   
    reg [3:0] cnt_bits, next_cnt_bits;
    reg parity_bit;    
    reg temp_parity_bit; // Registro auxiliar para la paridad

    // Lógica Secuencial
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state           <= IDLE;
            tx1             <= 1'b0;
            data_register   <= 8'b0;
            contador        <= 4'b0;
            parity_bit      <= 1'b0;
            temp_parity_bit <= 1'b0;
            cnt_bits        <= 0;
            bit_counter     <= 0;
        end else begin
            state           <= next_state;
            cnt_bits        <= next_cnt_bits;
        end 
    end

// Lógica Combinacional
always @(*) begin
    // Sosteniendo valores de FF.
    next_state = state;
    next_cnt_bits = cnt_bits;
    
    // Valores de salida por defecto.
    idle_bit = 1; // idle_bit = 1 a menos que estemos en el estado IDLE
    // Casos para cada estado.
    case(state)
        IDLE: begin
            idle_bit  = 0; // idle_bit = 1 a menos que estemos en el estado IDLE
            tx1       = 1'b1;
            if (!idle_bit) next_state = START;
        end
        START: begin
            tx1        = 1'b0;
            next_state = DATA;
        end
        DATA: begin
            tx1 = data_in[0 + cnt_bits];
            next_cnt_bits = cnt_bits + 1;
            if (cnt_bits == 7) begin
                next_state  = PARITY;
                
            end
        end
        PARITY: begin
            parity_bit   = ^data_in;
            tx1          = parity_bit;
            next_state   = STOP;
        end

        STOP: begin
            if (stop_bit) tx1 = 1'b1;
            tx1 = 1;
            next_state = IDLE;
        end
        //default: next_state = IDLE;
        
    endcase
end

endmodule