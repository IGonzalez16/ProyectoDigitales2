module gen_paridad (
    input [6:0] data,   //datos sobre los que se generará el bit de paridad
    input parimpar,     //entrada que determina el tipo de paridad deseada
    output wire paridad // salida que contiene el bit de paridad calculado
);
    assign paridad = (^data) ^ parimpar;
    
endmodule
