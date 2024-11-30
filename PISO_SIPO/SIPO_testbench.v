`include "SIPO_dut.v"
`include "SIPO_test.v"

module sipo_testbench;

wire clk;
wire rst;
wire serial_in;
wire [7:0] parallel_out;

sipo_dut dut (
    .clk(clk),
    .rst(rst),
    .serial_in(serial_in),
    .parallel_out(parallel_out)
);

sipo_test test (
    .clk(clk),
    .rst(rst),
    .serial_in(serial_in),
    .parallel_out(parallel_out)
);

initial begin
    $dumpfile("sipo_testbench.vcd");
    $dumpvars(0, sipo_testbench);
end

endmodule
