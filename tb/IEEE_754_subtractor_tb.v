`timescale 1ns / 1ps

module IEEE_754_subtractor_tb;

    reg [31:0] a, b;
    wire [31:0] result;
    wire valid;

    // Instantiate the DUT
    IEEE_754_subtractor uut (
        .a(a),
        .b(b),
        .result(result),
        .valid(valid)
    );

    initial begin
        // Test Case 1: 8.0 - 4.0 = 4.0
        a = 32'h41000000; // 8.0
        b = 32'h40800000; // 4.0
        #10;
        $display("Test 1: 8.0 - 4.0 | Expected: 4.0 | Result: %h", result);

        // Test Case 2: 5.5 - 2.5 = 3.0
        a = 32'h40B00000; // 5.5
        b = 32'h40200000; // 2.5
        #10;
        $display("Test 2: 5.5 - 2.5 | Expected: 3.0 | Result: %h", result);

        // Test Case 3: -10.0 - (-2.0) = -8.0
        a = 32'hC1200000; // -10.0
        b = 32'hC0000000; // -2.0
        #10;
        $display("Test 3: -10.0 - (-2.0) | Expected: -8.0 | Result: %h", result);

        // Test Case 4: 0.0 - 5.0 = -5.0
        a = 32'h00000000; // 0.0
        b = 32'h40A00000; // 5.0
        #10;
        $display("Test 4: 0.0 - 5.0 | Expected: -5.0 | Result: %h", result);

        // Test Case 5: 1.5 - 1.5 = 0.0
        a = 32'h3FC00000; // 1.5
        b = 32'h3FC00000; // 1.5
        #10;
        $display("Test 5: 1.5 - 1.5 | Expected: 0.0 | Result: %h", result);

        // Test Case 6: -2.5 - (-3.5) = 1.0
        a = 32'hC0200000; // -2.5
        b = 32'hC0600000; // -3.5
        #10;
        $display("Test 6: -2.5 - (-3.5) | Expected: 1.0 | Result: %h", result);

        // Test Case 7: Large number subtraction
        a = 32'h42C80000; // 100.0
        b = 32'h41C80000; // 25.0
        #10;
        $display("Test 7: 100.0 - 25.0 | Expected: 75.0 | Result: %h", result);

        // End simulation
        $finish;
    end

endmodule
