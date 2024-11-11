`include "mod10_dut.v"
`include "mod10_tester.v"

module mod10_tb;

wire clk; 
wire rst;
wire incremento;
wire contador10;

mod10 dut (
    .clk(clk),
    .rst(rst),
    .incremento(incremento),
    .contador10(contador10)
);

mod10_tester tester (
    .clk(clk),
    .rst(rst),
    .incremento(incremento),
    .contador10(contador10)
);

initial begin
    $dumpfile("testbench.vcd");
    $dumpvars;
end

endmodule
