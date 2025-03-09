module IEEE_754_divider (
    input  [31:0] a,  // IEEE 754 floating-point input A
    input  [31:0] b,  // IEEE 754 floating-point input B
    output reg [31:0] result, // IEEE 754 output
    output reg valid // Division valid flag
);

    // Extract fields from IEEE 754 representation
    wire sign_a = a[31];
    wire sign_b = b[31];
    wire [7:0] exp_a = a[30:23];
    wire [7:0] exp_b = b[30:23];
    wire [23:0] mant_a = {1'b1, a[22:0]}; // Add implicit leading 1
    wire [23:0] mant_b = {1'b1, b[22:0]}; // Add implicit leading 1

    // Compute sign of the result
    wire sign_res = sign_a ^ sign_b;

    // Exponent calculation with bias adjustment
    reg [8:0] exp_res;
    reg [23:0] quotient;
    reg [47:0] dividend;
    reg [23:0] divisor;
    integer i;

    always @(*) begin
        valid = 0; // Default invalid output

        // Handle special cases
        if (b == 32'h00000000) begin
            if (a == 32'h00000000) 
                result = 32'h7FC00000; // NaN (0/0)
            else
                result = (sign_res) ? 32'hFF800000 : 32'h7F800000; // +/- Infinity
            valid = 1;
        end else if (a == 32'h00000000) begin
            result = 32'h00000000; // Zero result
            valid = 1;
        end else if (exp_a == 8'hFF || exp_b == 8'hFF) begin
            if (exp_a == 8'hFF && mant_a != 24'h800000) 
                result = 32'h7FC00000; // NaN (a is NaN)
            else if (exp_b == 8'hFF && mant_b != 24'h800000)
                result = 32'h7FC00000; // NaN (b is NaN)
            else if (exp_a == 8'hFF) 
                result = (sign_res) ? 32'hFF800000 : 32'h7F800000; // a is Inf, result is Inf
            else
                result = 32'h00000000; // Anything / Inf = 0
            valid = 1;
        end else begin
            // Normal division process
            exp_res = exp_a - exp_b + 127; // Exponent adjustment

            // Initialize division
            dividend = mant_a << 1;  // Align dividend
            divisor = mant_b;
            quotient = 0;

            // Perform restoring division
            for (i = 0; i < 24; i = i + 1) begin
                quotient = quotient << 1;
                if (dividend >= divisor) begin
                    dividend = dividend - divisor;
                    quotient[0] = 1;
                end
                dividend = dividend << 1;
            end

            // Normalize mantissa (ensure leading 1)
            if (quotient[23] == 0) begin
                quotient = quotient << 1;
                exp_res = exp_res - 1;
            end

            // Construct final IEEE 754 result
            result = {sign_res, exp_res[7:0], quotient[22:0]};
            valid = 1;
        end
    end
endmodule
