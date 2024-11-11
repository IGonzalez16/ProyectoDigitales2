module shiftReg (
    input clk, carga, shift,   // carga es la señal que indica si los datos (cargaData) deben cargarse en el registro
                               // shift es la señal que permite desplazar los bits en el registro
    input [7:0] cargaData,     // vector de entrada de 8 bits que representa los datos que se cargarán en el registro
    output sout                // bit de salida, que es el bit menos significativo (q[0]) del registro de desplazamiento
);
    reg [8:0] q;               // registro de 9 bits que almacena el estado actual del registro de desplazamiento
    wire [8:0] ns;             // vector de 9 bits que representa el siguiente estado del registro.

    assign ns = (carga & shift) ? 9'b111111111 :
                 carga ? {cargaData, 1'b0} :
                 shift ? {1'b1, q[8:1]} :
                         q;

    always @(posedge clk) begin
        if (carga || shift)  // se actualiza el registro si carga o shift están activos
            q <= ns;
    end
    
    assign sout = q[0];  // la salida sout es el bit menos significativo del registro

endmodule
