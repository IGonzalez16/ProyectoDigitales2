module UART2_dut(
    input wire clk_uart,                               // Reloj principal del módulo UART
    input wire clk_sis,                                // Reloj del sistema 
    input wire rst,                                    
    input wire start_bit,                              // Indica el inicio de la transmisión
    input wire [7:0] data_in_2,                          // Dato de 8 bits a transmitir en serie
    input wire stop_bit,                               // Indica el fin de la transmisión
    input wire rx2,                                    // Linea de recepcion serie desde UART2
    output reg tx2,                                    // Línea de transmisión serie hacia UART2
    output reg [7:0] data_out                                    
);

    // Declaración de los estados del transmisor UART
    localparam IDLE = 3'b000,                       
               START = 3'b001,                      
               DATA = 3'b010,                       
               PARITY = 3'b011,                     
               STOP = 3'b100;                       

    reg [2:0] state, next_state;                       // Estado actual y siguiente
    reg idle_bit;                                      // Bandera para indicar si el sistema está en reposo
    reg [3:0] cnt_bits, next_cnt_bits;                 // Contador para rastrear los bits transmitidos
    reg parity_bit;                                    // Almacena el bit de paridad calculado
    reg [7:0] shift_register; 
    reg [2:0] cont_bit;       
    reg update_out;                                      

    // **Lógica Secuencial
    always @(posedge clk_uart or posedge rst) begin
        if (rst) begin
            // Reinicia todos los registros al estado inicial
            state        <= IDLE;                      // Comienza en el estado IDLE
            tx2          <= 1'b1;                      // Línea en alto (reposo)
            parity_bit   <= 1'b0;                      // Inicializa el bit de paridad
            cnt_bits     <= 4'b0;
            idle_bit = 1;                      // Reinicia el contador de bits
        end else begin
            // Actualización de los registros en función de la lógica combinacional
            state        <= next_state;               
            cnt_bits     <= next_cnt_bits;            
        end
    end

    // **Lógica Combinacional
    always @(*) begin
        // Valores predeterminados para evitar latches
        next_state = state;                           // Por defecto, el estado no cambia
        next_cnt_bits = cnt_bits;                     // Por defecto, el contador no cambia

        // Máquina de estados finita (FSM) //Se va armando la señal de tx2.
        case (state)
            IDLE: begin
                idle_bit = 1;                         
                tx2 = 1'b1;                           
                if (idle_bit) 
                    next_state = START;              
            end

            START: begin
                idle_bit = 0;
                tx2 = 1'b0;             
                next_state = DATA;      
            end

            DATA: begin
                // Transmite los bits de datos en serie uno por uno
                idle_bit = 0;
                tx2 = data_in_2[cnt_bits];    // Selecciona el bit correspondiente LSB
                next_cnt_bits = cnt_bits + 1;
                data_out[0 + cnt_bits] = rx2; 
                if (cnt_bits == 7)          // Si todos los bits han sido transmitidos
                    next_state = PARITY;    
            end

            PARITY: begin
                idle_bit = 0;
                parity_bit = ^(data_in_2);      // Calcula la paridad XOR de los datos
                tx2 = parity_bit;           // Transmite el bit de paridad
                next_state = STOP;          // Cambia al estado de parada
            end

            STOP: begin
                idle_bit = 0;
                tx2 = 1'b1;                 // Transmite el bit de parada (alto)
                if (stop_bit) 
                    next_state = IDLE;      
            end
        endcase
    end
endmodule