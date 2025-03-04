// Created: February 22, 2025
// Author - Aditya Vikram Singh
`include "../rtl/IEEE_754_adder.v"
`include "../rtl/IEEE_754_multiplier.v"

module pro_ele(
    input [31:0] w, // weights
    input [31:0] x_in, // input
    input [31:0] b, // base
    input [9:0] count, // counter for operation
    input head, // header
    input clock, // clock signal
    output reg [31:0] pe_out, // output of processing element
    output reg done_flag // flag when operations are done
);

// When head is HIGH, x_in contains the count of iterations
reg [9:0] final_count; // Final count till the counter reaches N
reg [9:0] counter_internal; // Internal counter

// Intermediate values
reg [31:0] i_w;
reg [31:0] i_x_in;
reg [31:0] i_b;

reg [31:0] accum; // Accumulator for intermediate sums
reg [31:0] add_p; // Partial sum per iteration
wire [31:0] add_n; // Multiplication result
wire [31:0] accum_w; // Addition result

// Instantiate Floating-Point Modules Outside Always Block
fp32_multiplier MULT (.a(i_w), .b(i_x_in), .product(add_n));
IEEE_754_adder ADDR (.in1(add_p), .in2(add_n), .out(accum_w));

always @(posedge clock) begin
    i_w <= w;
    i_x_in <= x_in;
    i_b <= b;
    
    if (head) begin
        final_count <= x_in[9:0]; // Extract count when head is HIGH
        add_p <= 32'h00000000;    // 
        accum <= 32'h00000000;
        counter_internal <= 10'b0000000000;
        done_flag <= 0; // Reset flag
    end 
    else if (counter_internal < final_count) begin
        accum <= accum_w; // Use computed value
        add_p <= accum_w; // 
        counter_internal <= counter_internal + 1'b1;
    end

    if (counter_internal == final_count - 1'b1) begin
        accum <= accum + b;
        pe_out <= accum;
        done_flag <= 1; // Set done flag
    end
end


endmodule
