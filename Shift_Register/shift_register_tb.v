`include "shift_register_dut.v"
`include "shift_register_test.v"
module shiftReg_tb;

wire clk; 
wire carga; 
wire shift;
wire [7:0] cargaData;
wire sout;

shiftReg dut (
    .clk(clk),
    .carga(carga),
    .shift(shift),
    .cargaData(cargaData),
    .sout(sout)
);

shiftReg_tester tester (
    .clk(clk),
    .carga(carga),
    .shift(shift),
    .cargaData(cargaData),
    .sout(sout)
);


initial begin
    $dumpfile("testbench.vcd");
    $dumpvars;
end

endmodule
