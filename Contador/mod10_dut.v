module mod10 (
    input clk, rst, incremento, // incremento es la señal que determina si el contador debe incrementar
    output reg contador10       // contador10 es la salida que indica cúando el contador ha llegado a 10 (o sea a 0)
);    
    reg [3:0] q;          // registro para almacenar el valor actual del contador
    wire [3:0] qMas1;     // señal para el siguiente valor de q

    // cálculo del próximo valor del contador
    assign qMas1 = (q == 9) ? 0 : q + 1;

    // bloque always que maneja rst, incremento y contador10
    always @(posedge clk) begin
        if (rst) begin
            q <= 0;                     // reinicia el contador si rst está activo
            contador10 <= 0;            // reinicia contador10 cuando se resetea
        end
        else if (incremento) begin
            q <= qMas1;                 // actualiza q al siguiente valor si incremento está activo
            contador10 <= (qMas1 == 0); // activa contador10 cuando q vuelve a 0 (o sea llega a 10)
        end
    end

endmodule
