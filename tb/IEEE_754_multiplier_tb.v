`timescale 1ns / 1ps

module fp32_multiplier_tb;

    reg [31:0] a, b;  // 32-bit floating-point inputs
    wire [31:0] product; // 32-bit floating-point result

    // Instantiate the floating-point multiplier
    fp32_multiplier uut (
        .a(a),
        .b(b),
        .product(product)
    );

    // Task to display IEEE 754 floating-point representation
    task display_result;
        input [31:0] a, b, product;
        begin
            $display("A = %h  B = %h  | Product = %h", a, b, product);
        end
    endtask

    initial begin
        $dumpfile("fp32_multiplier_tb.vcd"); // Dump waveform file
        $dumpvars(0, fp32_multiplier_tb);

        // Test Case 1: Multiply two positive numbers
        a = 32'h40400000;  // 3.0
        b = 32'h40800000;  // 4.0
        #10 display_result(a, b, product); // Expected: 12.0 (0x41400000)

        // Test Case 2: Multiply a positive and a negative number
        a = 32'hC0200000;  // -2.5
        b = 32'h40200000;  // 2.5
        #10 display_result(a, b, product); // Expected: -6.25 (0xC0C80000)

        // Test Case 3: Multiply with zero
        a = 32'h00000000;  // 0.0
        b = 32'h3F800000;  // 1.0
        #10 display_result(a, b, product); // Expected: 0.0 (0x00000000)

        // Test Case 4: Multiply two negative numbers
        a = 32'hC1200000;  // -10.0
        b = 32'hC0A00000;  // -5.0
        #10 display_result(a, b, product); // Expected: 50.0 (0x42480000)

        // Test Case 5: Multiply large numbers
        a = 32'h4B000000;  // 8388608.0
        b = 32'h4A800000;  // 4194304.0
        #10 display_result(a, b, product); // Expected: Very large number

        // Test Case 6: Multiply with infinity
        a = 32'h7F800000;  // +Infinity
        b = 32'h40000000;  // 2.0
        #10 display_result(a, b, product); // Expected: +Infinity

        // Test Case 7: Multiply infinity with zero (should be NaN)
        a = 32'h7F800000;  // +Infinity
        b = 32'h00000000;  // 0.0
        #10 display_result(a, b, product); // Expected: NaN (0x7FC00000)

        // Test Case 8: Multiply two NaNs
        a = 32'h7FC00000;  // NaN
        b = 32'h3F800000;  // 1.0
        #10 display_result(a, b, product); // Expected: NaN

        // Test Case 9: Overflow case
        a = 32'h7F7FFFFF;  // Largest normalized number
        b = 32'h7F7FFFFF;  
        #10 display_result(a, b, product); // Expected: +Infinity

        // Test Case 9: Overflow case
        a = 32'h3C23D70A;  // Largest normalized number
        b = 32'hBE800000;  
        #10 display_result(a, b, product); // Expected: +Infinity

        // Test Case 9: Overflow case
        a = 32'hBCCCCCCD;  // Largest normalized number
        b = 32'hBB656042;  
        #10 display_result(a, b, product); // Expected: +Infinity

        // End simulation
        $finish;
    end

endmodule
