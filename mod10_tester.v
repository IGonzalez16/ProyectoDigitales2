`timescale 1ns / 1ps
module mod10_tester(

    output reg clk, rst, incremento,
    input wire contador10

);

initial clk = 0;
always #10 clk = ~clk;

initial begin
    rst = 1;
    incremento = 0;
    
    #20;
    rst = 0;
    incremento = 1;
    
    // Ejecutar 20 ciclos de reloj
    repeat (20) begin
        #20;
    end
    
    $finish;
end

endmodule
