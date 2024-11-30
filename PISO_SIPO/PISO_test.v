`timescale 1ns/1ps

module piso_test(
    output reg clk,
    output reg rst,
    output reg load,
    output reg [7:0] parallel_in,
    input serial_out
);

always begin
    #5 clk = ~clk; 
end

initial begin
    clk = 1; 
    rst = 1;
    load = 0;
    parallel_in = 8'b0;

    
    #10 rst = 0;

    
    load = 1;
    parallel_in = 8'b11001011; 
    #10 load = 0;
    #70;
    parallel_in = 8'b0;

    #100;
    $finish;
end

endmodule
