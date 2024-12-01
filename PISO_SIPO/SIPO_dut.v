module sipo_dut (
    input clk, rst, serial_in,
    output reg [7:0] parallel_out
);

reg [7:0] shift_register; 
reg [2:0] cont_bit;       
reg update_out;           

always @(posedge clk or posedge rst) begin
    if (rst) begin
        parallel_out <= 8'b0;
        shift_register <= 8'b0;
        cont_bit <= 3'b0;
        update_out <= 1'b0;
    end else begin
        
        shift_register <= {shift_register[6:0], serial_in}; 
        cont_bit <= cont_bit + 1;

        
        if (cont_bit == 3'b111) begin
            update_out <= 1'b1; 
            cont_bit <= 3'b0;  
        end else begin
            update_out <= 1'b0; 
        end
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        parallel_out <= 8'b0;
    end else if (update_out) begin
        parallel_out <= shift_register; 
    end
end

endmodule