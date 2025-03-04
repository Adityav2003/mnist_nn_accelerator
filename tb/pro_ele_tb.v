`timescale 1ns/1ps

module proElement_tb;

    // Testbench signals
    reg [31:0] w;
    reg [31:0] x_in;
    reg [31:0] b;
    reg [9:0] count;
    reg head;
    reg clock;
    wire [31:0] pe_out;
    wire done_flag;

    // Instantiate the DUT (Device Under Test)
    pro_ele dut (
        .w(w),
        .x_in(x_in),
        .b(b),
        .count(count),
        .head(head),
        .clock(clock),
        .pe_out(pe_out),
        .done_flag(done_flag)
    );

    // Clock generation (50MHz, period = 20ns)
    always #10 clock = ~clock;

task header;
    input [31:0] head_bit;
    begin
        @(negedge clock); // Wait for negative edge of clock
        head = 1'b1;
        x_in = head_bit;

        @(negedge clock); // Wait for another negative edge
        head = 1'b0;
    end
endtask


    // Test procedure
    initial begin
        // Enable waveform dump for GTKWave
        $dumpfile("proElement_tb.vcd"); // Generates VCD file for GTKWave
        $dumpvars(0, proElement_tb);    // Dump all variables in the testbench
        $dumpvars(1, proElement_tb.dut); 
        
        // Initialize signals
        clock = 0;
        head = 0;
        
	    header(32'h00000009);

        w = 32'h3F800000; // 1.0 in IEEE 754
        x_in = 32'h40000000; // 2.0 in IEEE 754
        b = 32'h3F000000; // 0.5 in IEEE 754
        count = 10;

        // Monitor values
        $monitor("Time=%0t | head=%b | count=%d | w=%h | x=%h | b=%h | pe_out=%h | done_flag=%b", 
                 $time, head, count, w, x_in, b, pe_out, done_flag);

        // Apply reset condition
        #20;
        //head = 1; // Start computation
        #20;
        //head = 0;

        // Wait for computation to finish
       // wait(done_flag);
        #200;

        $display("Test Completed!");
        $finish;
    end

endmodule
