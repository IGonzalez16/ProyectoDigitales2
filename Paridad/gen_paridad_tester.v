`timescale 1ns / 1ps
module gen_paridad_tester(

    output reg [6:0] data,      
    output reg parimpar,         
    input wire paridad          
);

initial begin
    // se inicializan las señales
    data = 7'b0000000; 
    parimpar = 0;

    // prueba 1: paridad par, data con número impar de 1's
    data = 7'b1000101;   // 3 bits en "1" (impar)
    parimpar = 0;        // paridad par
    #10;
    $display("Prueba 1 - data = %b, parimpar = %b, paridad = %b", data, parimpar, paridad);

    // prueba 2: paridad impar, data con número impar de 1's
    data = 7'b1000101;   // 3 bits en "1" (impar)
    parimpar = 1;        // paridad impar
    #10;
    $display("Prueba 2 - data = %b, parimpar = %b, paridad = %b", data, parimpar, paridad);

    // prueba 3: paridad par, data con número par de 1's
    data = 7'b1100110;   // 4 bits en "1" (par)
    parimpar = 0;        // paridad par
    #10;
    $display("Prueba 3 - data = %b, parimpar = %b, paridad = %b", data, parimpar, paridad);

    // prueba 4: Paridad impar, data con número par de 1's
    data = 7'b1100110;   // 4 bits en "1" (par)
    parimpar = 1;        // paridad impar
    #10;
    $display("Prueba 4 - data = %b, parimpar = %b, paridad = %b", data, parimpar, paridad);

    // prueba adicional para validar otras combinaciones de bits
    data = 7'b1111111;   // 7 bits en "1" (impar)
    parimpar = 1;        // paridad impar
    #10;
    $display("Prueba 5 - data = %b, parimpar = %b, paridad = %b", data, parimpar, paridad);

    $finish;
end

endmodule
