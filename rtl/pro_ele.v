`include "../rtl/IEEE_754_adder.v"
`include "../rtl/IEEE_754_multiplier.v"

module pro_ele(
    input [31:0] w, // weights
    input [31:0] x_in, // input
    input [31:0] b, // bias
    //input [9:0] count, // counter for operation
    input head, // header signal
    input clock, // clock signal
    output reg [31:0] pe_out, // output of processing element
    output reg done_flag // flag indicating completion
);

// Internal registers
reg [9:0] final_count; // Stores the count extracted from x_in
reg [9:0] counter_internal; // Internal counter
reg [31:0] accum; // Accumulator for intermediate sums

reg [31:0] base_i;

// Floating-point multiplication and addition
wire [31:0] add_n;    // Multiplication result (w * x_in)
wire [31:0] accum_w;  // Addition result (accum + add_n)
wire  [31: 0] b_a_out; // base and add output

// Instantiate Floating-Point Modules
fp32_multiplier MULT (.a(w), .b(x_in), .product(add_n));
IEEE_754_adder ADDR (.in1(accum), .in2(add_n), .out(accum_w));
IEEE_754_adder ADDRB(.in1(accum_w), .in2(base_i), .out(b_a_out));

always @(posedge clock) begin
    if (head) begin
        // Reset condition
        final_count <= x_in[9:0]; // Extract count when head is HIGH
        accum <= 32'h00000000; // Reset accumulator
        counter_internal <= 10'b0000000000;
        done_flag <= 0;
        base_i <= b;
    end 
    else if (counter_internal < final_count) begin
        // Perform MAC (Multiply-Accumulate) operation
        accum <= accum_w; // Update accumulator
        counter_internal <= counter_internal + 1'b1;

        // Add bias on the last iteration
        // if (counter_internal == final_count - 1'b1) begin
            
        // end
    end

    // Final update and flag setting
    if (counter_internal == final_count) begin
          // Ensure final result is stored
        pe_out <= b_a_out;
        done_flag <= 1;
    end
end

endmodule
