`timescale 1ns / 1ps

module IEEE_754_expFunction_tb;

    reg [7:0] x;  // 8-bit integer input
    wire [31:0] exp_x; // IEEE 754 floating-point output

    IEEE_754_expFunction uut (
        .x(x),
        .exp_out(exp_x)
    );

    initial begin
        $monitor("Input: %d, exp(x): %h", x, exp_x);

        x = 8'd0;  #10; // exp(0) = 3F800000
        x = 8'd1;  #10; // exp(1) ≈ 402DF854
        x = 8'd2;  #10; // exp(2) ≈ 4085A3D7
        x = 8'd5;  #10; // exp(5) ≈ 4144A570
        x = 8'd10; #10; // exp(10) ≈ 43371B42
        x = 8'd15; #10; // exp(15) -> INF (7F800000)
        x = 8'd255; #10; // exp(255) -> INF (7F800000)

        $finish;
    end

endmodule
