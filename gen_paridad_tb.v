`include "gen_paridad_dut.v"
`include "gen_paridad_tester.v"

module gen_paridad_tb;

    wire [6:0] data;       
    wire parimpar;         
    wire paridad;         

    gen_paridad dut (
        .data(data),
        .parimpar(parimpar),
        .paridad(paridad)
    );

    gen_paridad_tester tester (
        .data(data),
        .parimpar(parimpar),
        .paridad(paridad)
    );

    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars;
    end

endmodule
