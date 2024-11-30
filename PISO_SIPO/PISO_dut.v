module piso_dut (
    input clk, rst, load,
    input [7:0] parallel_in,
    output reg serial_out,
    output reg parallel_in_active 
);

reg [7:0] shift_register; 
reg [3:0] bit_counter;    
reg serial_out_ready;     

always @(posedge clk or posedge rst) begin
    if (rst) begin
        shift_register <= 8'b0;
        serial_out <= 1'b0;
        bit_counter <= 4'b0;
        parallel_in_active <= 1'b0;
        serial_out_ready <= 1'b0; 
    end else if (load) begin
        
        shift_register <= parallel_in;
        parallel_in_active <= 1'b1; 
        bit_counter <= 4'b0;        
        serial_out <= 1'b0;         
        serial_out_ready <= 1'b0;   
    end else if (parallel_in_active) begin
        
        bit_counter <= bit_counter + 1;
        
        if (bit_counter == 4'b0111) begin
            parallel_in_active <= 1'b0;  
            serial_out_ready <= 1'b1;    
        end
    end else if (serial_out_ready) begin
        
        serial_out <= shift_register[7];
        shift_register <= {shift_register[6:0], 1'b0}; 
        bit_counter <= bit_counter + 1;

        
        if (bit_counter == 4'b0111) begin
            serial_out_ready <= 1'b0; 
            bit_counter <= 4'b0;      
        end
    end
end

endmodule
