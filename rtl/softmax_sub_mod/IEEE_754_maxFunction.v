`timescale 1ns / 1ps

module IEEE_754_maxFunction #(
    parameter N = 4  // Number of inputs
) (
    input wire clk,
    input wire rst,
    input wire valid_in,  // Signal to indicate a new input is available
    input wire [31:0] data_in,  // IEEE 754 floating-point number input
    output reg [31:0] max_val   // Maximum value output
);

    reg [31:0] temp_max;
    reg [2:0] count;  // Counter to track input sequence

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temp_max <= 32'h80000000; // Initialize with a very small number
            max_val <= 32'h80000000;
            count <= 0;
        end else if (valid_in) begin
            if (count == 0) begin
                temp_max <= data_in;  // Set first value as max initially
            end else begin
                // Compare exponent and mantissa for floating-point numbers
                if (data_in[30:0] > temp_max[30:0] || 
                   (data_in[30:0] == temp_max[30:0] && data_in[31] == 0)) begin
                    temp_max <= data_in;
                end
            end
            count <= count + 1;

            if (count == N - 1) begin
                max_val <= temp_max;  // Final max value after N inputs
            end
        end
    end
endmodule
