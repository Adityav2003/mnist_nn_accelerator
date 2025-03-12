`timescale 1ns / 1ps

module IEEE_754_softmax_tb;
    parameter N = 4;
    
    reg clk, rst, valid_in;
    reg [31:0] data_in;
    wire [31:0] softmax_out;
    wire valid_out;

    IEEE_754_softmax #(N) uut (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .data_in(data_in),
        .softmax_out(softmax_out),
        .valid_out(valid_out)
    );

    always #5 clk = ~clk; // Clock generation (10ns period)

    initial begin
        clk = 0;
        rst = 1;
        valid_in = 0;
        #10 rst = 0;

        // Input values: { -1.2, 0.5, 2.0, 3.1 }
        valid_in = 1;
        data_in = 32'hBF99999A; #10; // -1.2
        data_in = 32'h3F000000; #10; // 0.5
        data_in = 32'h40000000; #10; // 2.0
        data_in = 32'h404CCCCD; #10; // 3.1

        valid_in = 0;

        #100; // Wait for results

        $display("Softmax Output: %h", softmax_out);
        $finish;
    end
endmodule
