`timescale 1ns / 1ps

module proElement_tb;

  // Testbench signals
  reg [31:0] w, x, b;
  reg [9:0] count;
  reg head, clock;
  wire [31:0] pe_out;
  wire done_flag;

  // Instantiate the DUT (Device Under Test)
  proElement DUT (
    .w(w),
    .x(x),
    .b(b),
    .count(count),
    .head(head),
    .clock(clock),
    .pe_out(pe_out),
    .done_flag(done_flag)
  );

  // Clock generation
  always #5 clock = ~clock; // 10ns period

  // Task: Initialize Inputs
  task initialize;
    begin
      clock = 0;
      w = 32'h3F800000; // 1.0 in IEEE-754
      x = 32'h40000000; // 2.0 in IEEE-754
      b = 32'h00000000; // 0.0
      count = 0;
      head = 0;
    end
  endtask

  // Task: Apply Input Stimulus
  task apply_stimulus(input [31:0] weight, input [31:0] input_x, input [31:0] base, input [9:0] final_count);
    begin
      w = weight;
      x = input_x;
      b = base;
      head = 1;
      #10 head = 0; // Remove header after 1 clock cycle
    end
  endtask

  // Task: Run Test
  task run_test;
    begin
      initialize;
      #10;
      apply_stimulus(32'h3F800000, 32'h40000000, 32'h00000000, 10);
      #100;
      $display("Final Output: %h", pe_out);
      $finish;
    end
  endtask

  // Test execution
  initial begin
    run_test;
  end

endmodule
