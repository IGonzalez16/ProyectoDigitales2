module mod10 (
    input clk, rst, incremento, //incremento es la señal que determina si el contador debe incrementar
    output reg contador10       //contador10 es la salida que indica cúando el contador ha llegado a 10 (o sea a 0)
);    
    reg [3:0] q;          // Registro para almacenar el valor actual del contador
    wire [3:0] qMas1;     // Señal para el siguiente valor de q

    // Cálculo del próximo valor del contador
    assign qMas1 = (q == 9) ? 0 : q + 1;

    // Bloque always que maneja rst, incremento y contador10
    always @(posedge clk) begin
        if (rst) begin
            q <= 0;                     // Reinicia el contador si rst está activo
            contador10 <= 0;            // Reinicia contador10 cuando se resetea
        end
        else if (incremento) begin
            q <= qMas1;                 // Actualiza q al siguiente valor si incremento está activo
            contador10 <= (qMas1 == 0); // Activa contador10 cuando q vuelve a 0 (o sea llega a 10)
        end
    end

endmodule
