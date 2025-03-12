`timescale 1ns / 1ps

module IEEE_754_expFunction (
    input wire [7:0] x,      // 8-bit integer input
    output reg [31:0] exp_out // IEEE 754 floating-point output
);

    reg [31:0] exp_lut [0:255]; // LUT for exp(x), supporting x = 0 to 255

    integer i;

    initial begin
        // Precompute exp(x) values in IEEE 754 format for x = 0 to 10 (Add more if needed)
        exp_lut[0]  = 32'h3F800000; // exp(0) = 1.0
        exp_lut[1]  = 32'h402DF854; // exp(1) ≈ 2.718
        exp_lut[2]  = 32'h4085A3D7; // exp(2) ≈ 7.389
        exp_lut[3]  = 32'h40AF67A6; // exp(3) ≈ 20.085
        exp_lut[4]  = 32'h40F5E621; // exp(4) ≈ 54.598
        exp_lut[5]  = 32'h4144A570; // exp(5) ≈ 148.413
        exp_lut[6]  = 32'h419A209B; // exp(6) ≈ 403.428
        exp_lut[7]  = 32'h41FCE15D; // exp(7) ≈ 1096.63
        exp_lut[8]  = 32'h4262D374; // exp(8) ≈ 2980.96
        exp_lut[9]  = 32'h42CCCE2B; // exp(9) ≈ 8103.08
        exp_lut[10] = 32'h43371B42; // exp(10) ≈ 22026.47
        
        // For larger values (x > 10), set output to infinity (IEEE 754 INF)
        
        for (i = 11; i < 256; i = i + 1) begin
            exp_lut[i] = 32'h7F800000; // IEEE 754 positive infinity
        end
    end

    always @(*) begin
        exp_out = exp_lut[x]; // Retrieve value from LUT
    end

endmodule
