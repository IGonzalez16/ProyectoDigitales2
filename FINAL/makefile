uart1:
	iverilog -o tb1.vvp UART1_tb.v
	vvp tb1.vvp
	gtkwave UART1_tb.vcd

clean1:
	rm -rf tb1.vvp UART1_tb.vcd

uart2:
	iverilog -o tb2.vvp UART2_tb.v
	vvp tb2.vvp
	gtkwave GTKWAVEUART2.gtkw

clean2:
	rm -rf tb2.vvp UART2_tb.vcd