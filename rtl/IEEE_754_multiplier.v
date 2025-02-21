module fp32_multiplier (
    input  [31:0] a,   
    input  [31:0] b,   
    output [31:0] product 
);

    
    wire sign_a = a[31];
    wire sign_b = b[31];
    wire [7:0] exp_a = a[30:23];
    wire [7:0] exp_b = b[30:23];
    wire [22:0] mant_a = a[22:0];
    wire [22:0] mant_b = b[22:0];

    
    wire sign_result = sign_a ^ sign_b;

    
    wire [24:0] mantissa_a = (|exp_a) ? {1'b1, mant_a} : {1'b0, mant_a};
    wire [24:0] mantissa_b = (|exp_b) ? {1'b1, mant_b} : {1'b0, mant_b};

    
    wire [49:0] mantissa_product = mantissa_a * mantissa_b;

    
    wire [8:0] exp_sum = exp_a + exp_b - 8'd127;

    // Normalize the mantissa product
    reg [7:0] exp_result;
    reg [22:0] mant_result;
    always @(*) begin
        if (mantissa_product[47]) begin
            
            mant_result = mantissa_product[46:24]; 
            exp_result = exp_sum + 1;
        end else begin
            
            mant_result = mantissa_product[45:23];
            exp_result = exp_sum;
        end
    end

    // Handle special cases: Zero, Infinity, NaN
    wire is_zero = (a == 32'h00000000 || b == 32'h00000000);
    wire is_inf = (exp_a == 8'hFF && mant_a == 0) || (exp_b == 8'hFF && mant_b == 0);
    wire is_nan = (exp_a == 8'hFF && mant_a != 0) || (exp_b == 8'hFF && mant_b != 0);

    assign product = is_nan ? 32'h7FC00000 :  // NaN
                     is_inf ? {sign_result, 8'hFF, 23'b0} : // Infinity
                     is_zero ? 32'h00000000 : // Zero
                     {sign_result, exp_result, mant_result}; // Normal case

endmodule
