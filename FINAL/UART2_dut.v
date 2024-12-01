module UART2_dut(
    input wire clk_sis,
    input wire clk_uart,
    input wire rst,
    input wire start_bit,
    input wire [7:0] data_in,
    input wire stop_bit,
    input wire rx2,
    output reg tx2
);

    localparam IDLE = 3'b000,
               START = 3'b001,
               DATA = 3'b010,
               PARITY = 3'b011,
               STOP = 3'b100;

    reg [2:0] state, next_state;  
    reg idle_bit;   
    reg [3:0] cnt_bits, next_cnt_bits;
    reg parity_bit;    

    // Lógica Secuencial
    always @(posedge clk_uart or posedge rst) begin
        if (rst) begin
            state           <= IDLE;
            tx2             <= 1'b0;
            parity_bit      <= 1'b0;
            cnt_bits        <= 0;
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
            tx2       = 1'b1;
            if (!idle_bit) next_state = START;
        end
        START: begin
            tx2        = 1'b0;
            next_state = DATA;
        end
        DATA: begin
            tx2 = data_in[0 + cnt_bits];
            next_cnt_bits = cnt_bits + 1;
            if (cnt_bits == 7) begin
                next_state  = PARITY;
                
            end
        end
        PARITY: begin
            parity_bit   = ^data_in;
            tx2          = parity_bit;
            next_state   = STOP;
        end

        STOP: begin
            if (stop_bit) tx2 = 1'b1;
            tx2 = 1;
            next_state = IDLE;
        end
        //default: next_state = IDLE;
        
    endcase
end

endmodule





