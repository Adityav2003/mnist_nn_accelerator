`timescale 1ns / 1ps

`include "../rtl/IEEE_754_adder.v"
`include "../rtl/IEEE_754_multiplier.v"
`include "../rtl/softmax_sub_mod/IEEE_754_divider.v"
`include "../rtl/softmax_sub_mod/IEEE_754_subtractor.v"
`include "../rtl/softmax_sub_mod/IEEE_754_exponent.v"
`include "../rtl/softmax_sub_mod/IEEE_754_maxFunction.v"

module IEEE_754_softmax #(
    parameter N = 4  // Number of inputs
) (
    input wire clk,
    input wire rst,
    input wire valid
    _in,            // New data valid signal
    input wire [31:0] data_in,      // IEEE 754 floating-point input
    output wire [31:0] softmax_out, // Softmax output
    output wire valid_out           // Output valid flag
);

    reg [31:0] exp_values [N-1:0];   // Stores exponentials
    reg [31:0] sum_exp;              // Sum of exponentials
    wire [31:0] max_val;              // Maximum value
    reg [31:0] temp_subtracted[N-1:0]; // Temporary values after subtraction

    wire [31:0] exp_out, sub_out, sum_out, div_out;
    wire valid_sub, valid_exp, valid_sum, valid_div;

    // Max Finder
    IEEE_754_maxFunction #(N) max_func (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .data_in(data_in),
        .max_val(max_val)
    );

    // Subtract max_val from each input
    IEEE_754_subtractor sub_func (
        .a(data_in),
        .b(max_val),
        .result(sub_out),
        .valid(valid_sub)
    );

    // Compute exponentials
    IEEE_754_expFunction exp_func (
        .x(sub_out[7:0]),  // Using lower 8 bits as index for LUT
        .exp_out(exp_out)
    );

    // Accumulate exponentials
    IEEE_754_adder sum_func (
        .in1(sum_exp),
        .in2(exp_out),
        .out(sum_out)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum_exp <= 32'h00000000;
        end else if (valid_sub) begin
            exp_values[0] <= exp_out; // Store exponentials
            sum_exp <= sum_out; // Update sum
        end
    end

    // Perform division exp(x_i) / sum_exp
    IEEE_754_divider div_func (
        .a(exp_values[0]),
        .b(sum_exp),
        .result(div_out),
        .valid(valid_div)
    );

    assign softmax_out = div_out;
    assign valid_out = valid_div;

endmodule
