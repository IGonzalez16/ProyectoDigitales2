`timescale 1ns/1ps

module sipo_test(
    output reg clk,
    output reg rst,
    output reg serial_in,
    input [7:0] parallel_out
);

always begin
    #5 clk = ~clk; 
end

initial begin
    clk = 1; 
    rst = 1;
    serial_in = 0;

    
    #10 rst = 0;
    
    serial_in = 1; #10; 
    serial_in = 1; #10; 
    serial_in = 1; #10; 
    serial_in = 0; #10; 
    serial_in = 1; #10; 
    serial_in = 0; #10; 
    serial_in = 0; #10; 
    serial_in = 0; #10; 

    serial_in = 0;

    #100;
    $finish;
end

endmodule
