module UART2_dut(
    // Entradas
    input wire clk_sis,                 // Reloj del sistema 
    input wire clk_uart,                // Reloj para las operaciones UART
    input wire rst,                     
    input wire start_bit,               
    input wire [7:0] data_in,           // Dato para paridad y transmisión en ⁠ tx2 ⁠)
    input wire stop_bit,                
    input wire rx2,                     // Línea de recepción en serie desde el transmisor
    // Salidas     
    output reg tx2,                     // Línea de transmisión en serie hacia el rx1
    output reg [7:0] data_out           // Salida paralela que almacena el dato recibido
);     

    // Definición de estados para la máquina de estados finita (FSM)
    localparam IDLE = 3'b000,           
               START = 3'b001,          
               DATA = 3'b010,           
               PARITY = 3'b011,         
               STOP = 3'b100;           

    // Registros internos para la FSM y la lógica del módulo
    reg [2:0] state, next_state;   
    reg idle_bit;                  
    reg [3:0] cnt_bits, next_cnt_bits;   // Contador de bits recibidos
    reg parity_bit;                      // Bit de paridad calculado
    reg [7:0] shift_register;            // Registro de desplazamiento para almacenar el dato recibido
    reg [2:0] cont_bit;                  // Contador auxiliar para desplazamiento en ⁠ data_out ⁠
    reg update_out;                      // Bandera para actualizar la salida paralela

    // *Lógica Secuencial*
    // Actualización del estado y registros en el flanco positivo del reloj o reset
    always @(posedge clk_uart or posedge rst) begin
        if (rst) begin
            // Inicialización de los registros en caso de reset
            state           <= IDLE;
            tx2             <= 1'b0;
            parity_bit      <= 1'b0;
            cnt_bits        <= 0;
        end else begin
            // Actualización de los estados y contadores
            state           <= next_state;
            cnt_bits        <= next_cnt_bits;
        end 
    end

    // *Lógica Combinacional*
    // Generación de los estados siguientes y valores de salida
    always @(*) begin
        // Valores predeterminados para evitar comportamientos indefinidos
        next_state = state;
        next_cnt_bits = cnt_bits;
        idle_bit = 1;                          // Por defecto, el sistema está en reposo

        // Máquina de estados finita (FSM)
        case(state)
            IDLE: begin
                idle_bit  = 0;                 // Detecta que estamos en reposo
                tx2       = 1'b1;              // Línea de transmisión en alto (estado inactivo)
                if (!idle_bit)                 // Si detecta actividad, pasa al estado START
                    next_state = START;
            end

            START: begin
                tx2        = 1'b0;             // Envía el bit de inicio
                next_state = DATA;             // Cambia al estado de recepción de datos
            end

            DATA: begin
                // Transmite el bit actual de ⁠ data_in ⁠ por ⁠ tx2 ⁠
                tx2 = data_in[0 + cnt_bits];
                // Incrementa el contador de bits recibidos
                next_cnt_bits = cnt_bits + 1;
                
                // Si se han recibido 8 bits, pasa al estado de paridad
                if (cnt_bits == 7) begin
                    next_state = PARITY; 
                end
                
                // Construye el dato paralelo a partir de los bits recibidos en ⁠ rx2 ⁠
                data_out[7 - cnt_bits] = rx2; 
                cont_bit = cont_bit + 1;         // Actualiza el contador auxiliar
            end

            PARITY: begin
                parity_bit   = ^data_in;         // Calcula el bit de paridad (XOR de ⁠ data_in ⁠)
                tx2          = parity_bit;       // Envía el bit de paridad por ⁠ tx2 ⁠
                next_state   = STOP;             // Cambia al estado de parada
            end

            STOP: begin
                // Envía el bit de parada (alto) y vuelve al estado IDLE
                if (stop_bit)
                    tx2 = 1'b1;
                next_state = IDLE;
            end
        endcase
    end

endmodule