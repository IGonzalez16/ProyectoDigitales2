uart1:
	iverilog -o tb.vvp UART1_tb.v
	vvp tb.vvp
	gtkwave UART1_tb.vcd

cleans:
	rm -rf tb.vvp UART1_tb.vcd