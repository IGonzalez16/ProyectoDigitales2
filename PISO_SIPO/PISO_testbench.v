`include "PISO_dut.v"
`include "PISO_test.v"

module piso_testbench;

wire clk;
wire rst;
wire load;
wire [7:0] parallel_in;
wire serial_out;

piso_dut dut (
    .clk(clk),
    .rst(rst),
    .load(load),
    .parallel_in(parallel_in),
    .serial_out(serial_out)
);

piso_test test (
    .clk(clk),
    .rst(rst),
    .load(load),
    .parallel_in(parallel_in),
    .serial_out(serial_out)
);

initial begin
    $dumpfile("piso_testbench.vcd");
    $dumpvars(0, piso_testbench);
end

endmodule
