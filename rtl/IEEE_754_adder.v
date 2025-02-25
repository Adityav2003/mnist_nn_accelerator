// author - ADITYA VIKRAM SINGH, SHIVA SHANKAR B
//created  - January 30, 2025
// we are testing github

module IEEE_754_adder(
    input [31:0] in1,
    input [31:0] in2,
    output [31:0] out
);

    wire sign_A = in1[31];
    wire sign_B = in2[31];
    wire [7:0] exp_A = in1[30:23];
    wire [7:0] exp_B = in2[30:23];
    wire [22:0] frac_A = in1[22:0];
    wire [22:0] frac_B = in2[22:0];
    
    reg [24:0] mant_A, mant_B; //23rd bit for after decimal and another for carry handling
    reg [7:0] exp_diff, exp_max;
    reg [24:0] mant_sum;
    reg sign_res;
    reg [7:0] exp_res;
    reg [31:0] result;


    always @(*) begin
        mant_A = {1'b1, frac_A}; // 1.M
        mant_B = {1'b1, frac_B}; // 1.M

        
        if (exp_A > exp_B) begin
            exp_diff = exp_A - exp_B;
            mant_B = mant_B >> exp_diff;
            exp_max = exp_A;
        end

        else begin
            exp_diff = exp_B - exp_A;
            mant_A = mant_A >> exp_diff;
            exp_max = exp_B;
        end
        
        if (sign_A == sign_B) begin
            mant_sum = mant_A + mant_B;
            sign_res = sign_A;
        end

        else begin
            if (mant_A >= mant_B) begin
                mant_sum = mant_A - mant_B;
                sign_res = sign_A;
            end
            else begin
                mant_sum = mant_B - mant_A;
                sign_res = sign_B;
            end
        end
        
        exp_res = exp_max;

        if(mant_sum[24] == 1 && mant_sum[23] == 0) begin
            mant_sum = mant_sum >> 1;
            exp_res = exp_res + 1;
        end

        while (mant_sum[23] == 0 && exp_res > 0) begin
            mant_sum = mant_sum << 1;
            exp_res = exp_res - 1;
        end
    
        result = {sign_res, exp_res, mant_sum[22:0]};

    end
    
    assign out = result;
    
endmodule
