sipo:
	iverilog -o tbs.vvp SIPO_testbench.v
	vvp tbs.vvp
	gtkwave sipo_testbench.vcd

cleans:
	rm -rf tbs.vvp sipo_testbench.vcd

piso:
	iverilog -o tbp.vvp PISO_testbench.v
	vvp tbp.vvp
	gtkwave piso_testbench.vcd

cleanp:
	rm -rf tbp.vvp piso_testbench.vcd

	

