`timescale 1ns / 1ps

module IEEE_754_divider_tb;
    reg  [31:0] a, b;      // Inputs
    wire [31:0] result;    // Output result
    wire valid;            // Validity flag

    // Instantiate the Divider module
    IEEE_754_divider uut (
        .a(a),
        .b(b),
        .result(result),
        .valid(valid)
    );

    // Function to display result in readable format
    function real ieee754_to_real;
        input [31:0] ieee;
        integer exp;
        real mantissa, value;
        begin
            exp = ieee[30:23] - 127;
            mantissa = 1.0 + (ieee[22:0] / (2.0**23));
            value = mantissa * (2.0**exp);
            if (ieee[31] == 1) value = -value;
            ieee754_to_real = value;
        end
    endfunction

    // Task to print test results
    task print_result;
        input [31:0] val;
        begin
            $display("Sign: %b | Exponent: %b | Mantissa: %b | IEEE 754: %h | Value: %f",
                     val[31], val[30:23], val[22:0], val, ieee754_to_real(val));
        end
    endtask

    // Testbench Stimulus
    initial begin
        $dumpfile("IEEE_754_divider_tb.vcd");  // For waveform viewing
        $dumpvars(0, IEEE_754_divider_tb);
        
        // Test Case 1: 10.5 / 3.5 = 3.0
        a = 32'h41280000;  // 10.5 in IEEE 754
        b = 32'h40600000;  // 3.5 in IEEE 754
        #10;
        $display("Test 1: 10.5 / 3.5");
        print_result(result);
        
        // Test Case 2: -15.75 / 2.25 = -7.0
        a = 32'hC1780000;  // -15.75 in IEEE 754
        b = 32'h40080000;  // 2.25 in IEEE 754
        #10;
        $display("Test 2: -15.75 / 2.25");
        print_result(result);

        // Test Case 3: 7.0 / 0.0 (Should return +Infinity)
        a = 32'h40E00000;  // 7.0 in IEEE 754
        b = 32'h00000000;  // 0.0 in IEEE 754
        #10;
        $display("Test 3: 7.0 / 0.0 (Expect +Infinity)");
        print_result(result);

        // Test Case 4: 0.0 / 5.5 = 0.0
        a = 32'h00000000;  // 0.0 in IEEE 754
        b = 32'h40B00000;  // 5.5 in IEEE 754
        #10;
        $display("Test 4: 0.0 / 5.5");
        print_result(result);

        // Test Case 5: Infinity / 2.0 = Infinity
        a = 32'h7F800000;  // +Infinity
        b = 32'h40000000;  // 2.0 in IEEE 754
        #10;
        $display("Test 5: Infinity / 2.0");
        print_result(result);

        // Test Case 6: NaN / 4.0 (Expect NaN)
        a = 32'h7FC00000;  // NaN
        b = 32'h40800000;  // 4.0 in IEEE 754
        #10;
        $display("Test 6: NaN / 4.0");
        print_result(result);

        // Test Case 7: Negative division (-8.0 / 4.0) = -2.0
        a = 32'hC1000000;  // -8.0 in IEEE 754
        b = 32'h40800000;  // 4.0 in IEEE 754
        #10;
        $display("Test 7: -8.0 / 4.0 (Expect -2.0)");
        print_result(result);

        // Test Case 8: Small values (0.015625 / 0.5)
        a = 32'h3C800000;  // 0.015625 in IEEE 754
        b = 32'h3F000000;  // 0.5 in IEEE 754
        #10;
        $display("Test 8: 0.015625 / 0.5");
        print_result(result);

        // Test Case 9: Large values (1e30 / 1e20)
        a = 32'h5E6E6B28;  // 1e30 in IEEE 754
        b = 32'h5138D1B7;  // 1e20 in IEEE 754
        #10;
        $display("Test 9: 1e30 / 1e20");
        print_result(result);

        // Test Complete
        $display("All tests completed.");
        $finish;
    end
endmodule
