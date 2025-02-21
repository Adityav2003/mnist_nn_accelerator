`timescale 1ns / 1ps

module IEEE_754_adder_tb;

    reg [31:0] in1, in2;
    wire [31:0] out;
    
    IEEE_754_adder uut (
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    
    initial begin
        $monitor("Time=%0t | in1=%h | in2=%h | out=%h", $time, in1, in2, out);
        
        // Test Case 1: 3.5 + 1.5 (expected ~5.0)
        in1 = 32'h40600000; // 3.5 in IEEE 754
        in2 = 32'h3FC00000; // 1.5 in IEEE 754
        #10;
        
        // Test Case 2: -2.75 + 1.25 (expected ~ -1.5)
        in1 = 32'hC02C0000; // -2.75 in IEEE 754
        in2 = 32'h3FA00000; // 1.25 in IEEE 754
        #10;
        
        // Test Case 3: 0.0 + 0.0 (expected 0.0)
        in1 = 32'h00000000; // 0.0 in IEEE 754
        in2 = 32'h00000000; // 0.0 in IEEE 754
        #10;
        
        // Test Case 4: Large numbers 100.5 + 200.25
        in1 = 32'h42C90000; // 100.5 in IEEE 754
        in2 = 32'h4340C000; // 200.25 in IEEE 754
        #10;
        
        // Test Case 5: Infinity + finite number
        in1 = 32'h7F800000; // +Infinity in IEEE 754
        in2 = 32'h3F800000; // 1.0 in IEEE 754
        #10;
        
        // Test Case 6: NaN + Number
        in1 = 32'h7FC00000; // NaN in IEEE 754
        in2 = 32'h40000000; // 2.0 in IEEE 754
        #10;

        //Test Case 7
        in1 = 32'h3DF5C28F;
        in2 = 32'h3CF5C28F;
        #10;
        
        $finish;
    end
    
endmodule
