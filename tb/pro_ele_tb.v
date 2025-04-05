`timescale 1ns/1ps

module proElement_tb;

    // Testbench signals
    reg [31:0] w;
    reg [31:0] x_in;
    reg [31:0] b;
    reg head;
    reg clock;
    wire [31:0] pe_out;
    wire done_flag;

    // Instantiate the DUT (Device Under Test)
    pro_ele dut (
        .w(w),
        .x_in(x_in),
        .b(b),
        //.count(10'b0), // Unused in design, so set to 0
        .head(head),
        .clock(clock),
        .pe_out(pe_out),
        .done_flag(done_flag)
    );

    // Clock generation (50MHz, period = 20ns)
    always #10 clock = ~clock;

    // Task: Apply header signal to load `final_count`
    task header;
        input [31:0] head_bit;
        begin
            @(negedge clock);
            head = 1'b1;
            x_in = head_bit; // Assign count value when head is high
            @(negedge clock);
            head = 1'b0; // Deassert head after 1 clock cycle
            x_in = 32'h3E800000;
        end
    endtask

    // Task: Provide input values for `count` clock cycles
    task provide_inputs;
        input [31:0] x_value;
        input [31:0] w_value;
        input [9:0] count; // Number of iterations
        begin
            repeat (count) begin
                @(negedge clock);
                x_in = x_value;
                w = w_value;
            end
        end
    endtask

    // Test procedure
    initial begin
        // Enable waveform dump for GTKWave debugging
        $dumpfile("proElement_tb.vcd"); 
        $dumpvars(0, proElement_tb);    
        $dumpvars(1, proElement_tb.dut); 
        
        // Initialize signals
        clock = 0;
        head = 0;
        w = 32'h3F000000;   // 0.5 in IEEE 754
        x_in = 32'h3E800000; // 0.25 in IEEE 754
        b = 32'h3F800000;    // 1.0 in IEEE 754

        // Apply header (sets `final_count`)
        header(32'h00000009); // Set final count to 9

        // Provide inputs over `final_count` cycles
        provide_inputs(32'h3E800000, 32'h3F000000, 9); // x = 0.25, w = 0.5, 9 iterations

        // Wait until `done_flag` is asserted
        wait (done_flag);
        @(posedge clock); // Ensure final value is captured

        // Display final output
        $display("Test Completed! Output: %h", pe_out);

        $finish;
    end

endmodule
