`timescale 1ns / 1ps

module IEEE_754_maxFunction_tb;
    parameter N = 4;
    
    reg clk;
    reg rst;
    reg valid_in;
    reg [31:0] data_in; 
    wire [31:0] max_val;

    // Instantiate the Max Finder module
    IEEE_754_maxFunction #(N) uut (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .data_in(data_in),
        .max_val(max_val)
    );

    // Clock Generation
    always #5 clk = ~clk;  // 10ns clock period

    initial begin

        $dumpfile("IEEE_754_maxFunction_tb.vcd");
        $dumpvars(0, IEEE_754_maxFunction_tb);
        clk = 0;
        rst = 1;
        valid_in = 0;
        data_in = 0;

        #10 rst = 0; // Release reset

        // Input values sequentially on clock edges
        #10 valid_in = 1; data_in = 32'hC0600000; // -3.5
        #10 valid_in = 1; data_in = 32'h40000000; // 2.0
        #10 valid_in = 1; data_in = 32'h40F00000; // 7.5 (Expected Max)
        #10 valid_in = 1; data_in = 32'hBF99999A; // -1.2
        #10 valid_in = 0; // Stop sending inputs

        #20;
        $display("Max Value: %h", max_val);
        
        if (max_val == 32'h40F00000) 
            $display("Test Passed!");
        else 
            $display("Test Failed!");

        #10 $finish;
    end
endmodule
