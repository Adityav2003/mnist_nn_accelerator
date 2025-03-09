module IEEE_754_subtractor (
    input  [31:0] a,  // IEEE 754 floating-point input A
    input  [31:0] b,  // IEEE 754 floating-point input B
    output reg [31:0] result, // IEEE 754 output
    output reg valid // Valid flag
);

    // Extract fields from IEEE 754 representation
    wire sign_a = a[31];
    wire sign_b = b[31] ^ 1'b1; // Flip sign for subtraction
    wire [7:0] exp_a = a[30:23];
    wire [7:0] exp_b = b[30:23];
    wire [23:0] mant_a = {1'b1, a[22:0]}; // Add implicit leading 1
    wire [23:0] mant_b = {1'b1, b[22:0]}; // Add implicit leading 1

    // Compute exponent difference
    reg [7:0] exp_res;
    reg [23:0] mant_res;
    reg sign_res;
    reg [23:0] shifted_mant;
    integer shift;

    always @(*) begin
        valid = 0;

        // Handle special cases
        if (a == b) begin
            result = 32'h00000000; // a - a = 0
            valid = 1;
        end else if (a == 32'h00000000) begin
            result = {sign_b, exp_b, mant_b[22:0]}; // -b
            valid = 1;
        end else if (b == 32'h00000000) begin
            result = a; // a - 0 = a
            valid = 1;
        end else begin
            // Align exponents
            if (exp_a > exp_b) begin
                shift = exp_a - exp_b;
                exp_res = exp_a;
                shifted_mant = mant_b >> shift;
                sign_res = sign_a;
            end else if (exp_b > exp_a) begin
                shift = exp_b - exp_a;
                exp_res = exp_b;
                shifted_mant = mant_a >> shift;
                sign_res = sign_b;
            end else begin
                exp_res = exp_a;
                shifted_mant = mant_b;
                sign_res = sign_a;
            end

            // Perform subtraction (larger mantissa first)
            if (mant_a >= shifted_mant) begin
                mant_res = mant_a - shifted_mant;
                sign_res = sign_a;
            end else begin
                mant_res = shifted_mant - mant_a;
                sign_res = sign_b;
            end

            // Normalize result (Shift left until the leading bit is 1)
            while (mant_res[23] == 0 && exp_res > 0) begin
                mant_res = mant_res << 1;
                exp_res = exp_res - 1;
            end

            // Ensure sign is set correctly when the result is positive
            if (mant_res == 0) begin
                result = 32'h00000000; // Ensure zero result has no sign bit set
            end else begin
                result = {sign_res, exp_res, mant_res[22:0]};
            end

            valid = 1;
        end
    end
endmodule
