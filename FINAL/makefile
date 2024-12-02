uart:
	iverilog -o tb.vvp UART_tb.v
	vvp tb.vvp
	gtkwave GTKFINAL.gtkw

clean:
	rm -rf tb.vvp UART_tb.vcd