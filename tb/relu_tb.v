`timescale 1ns / 1ps

module relu_tb;

    // Testbench signals
    reg clock;
    reg [31:0] relu_in;
    reg relu_valid;
    wire [31:0] relu_out;
    wire relu_done;

    // Instantiate the ReLU module
    relu uut (
        .clock(clock),
        .relu_in(relu_in),
        .relu_valid(relu_valid),
        .relu_out(relu_out),
        .relu_done(relu_done)
    );

    // Clock generation (50 MHz -> 10 ns period)
    always #5 clock = ~clock;

    // Task to print results in decimal format
    task print_result;
        input [31:0] ieee754;
        begin
            $display("Time=%0t | Input=%h | Output=%h | Valid=%b | Done=%b", 
                     $time, ieee754, relu_out, relu_valid, relu_done);
        end
    endtask

    initial begin
        // Initialize signals
        clock = 0;
        relu_in = 0;
        relu_valid = 0;
        
        // Apply test cases using IEEE 754 hex values
        #10 relu_in = 32'hC1233333; relu_valid = 1; // -10.2 -> Should output 0
        #10 print_result(relu_in);

        #10 relu_in = 32'h3FCCCCCD; relu_valid = 1; // 1.6 -> Should output 1.6
        #10 print_result(relu_in);

        #10 relu_in = 32'hBF400000; relu_valid = 1; // -0.75 -> Should output 0
        #10 print_result(relu_in);

        #10 relu_in = 32'h00000000; relu_valid = 1; // 0.0 -> Should output 0
        #10 print_result(relu_in);

        #10 relu_in = 32'h42C04000; relu_valid = 1; // 96.125 -> Should output 96.125
        #10 print_result(relu_in);

        #10 relu_in = 32'hC2480000; relu_valid = 1; // -50.0 -> Should output 0
        #10 print_result(relu_in);

        #10 relu_valid = 0; // Disable valid flag

        #20 $stop; // End simulation
    end

endmodule

