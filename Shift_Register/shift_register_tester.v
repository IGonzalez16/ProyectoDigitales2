`timescale 1ns / 1ps

module shiftReg_tester(
    output reg clk, 
    output reg carga,
    output reg shift,
    output reg [7:0] cargaData,
    input wire sout
);

initial clk = 0;
always #5 clk = ~clk; 

initial begin
    // se inicializan las señales
    carga = 0;
    shift = 0;
    cargaData = 8'b00000000; 

    #10;
    
    // prueba 1: cargar datos en el registro (carga = 1)
    cargaData = 8'b10101010; // Cargar los datos 0b10101010
    carga = 1;
    shift = 0; // no desplazar
    #10;
    carga = 0;  // desactivar carga

    // prueba 2: desplazar datos (shift = 1)
    shift = 1;
    #10;  // desplazar una vez
    shift = 0;  // detener el desplazamiento
    
    // prueba 3: cargar datos nuevamente y luego desplazarlos
    cargaData = 8'b11001100; // cargar los datos 0b11001100
    carga = 1;
    #10;
    carga = 0;
    
    // prueba 4: realizar varios desplazamientos
    shift = 1;
    #50; 

    $finish;
end

endmodule
