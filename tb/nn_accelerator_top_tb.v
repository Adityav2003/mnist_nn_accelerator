`timescale 1ns / 1ps

module nn_accelerator_top_tb;
    reg clock;
    reg rst;
    reg hard_rst;
    wire [31:0] values;
    
    // Instantiate the top module
    nn_accelerator_top uut (
        .clock(clock),
        .rst(rst),
        .hard_rst(hard_rst),
        .values(values)
    );
    
    // Clock generation
    always #5 clock = ~clock;
    
    initial begin
        $dumpfile("nn_accelerator_top_tb.vcd"); 
        $dumpvars(0, nn_accelerator_top_tb);    
        $dumpvars(1, nn_accelerator_top_tb.uut);
        // Initialize signals
        clock = 0;
        rst = 1;
        hard_rst = 0; // Ensure hard reset is never set to 1
        
        #10 rst = 0; // De-assert reset after some time
        
        // Apply test cases
        //#20 $monitor("Values Output: %h", values);
        
        #5000 $finish; // End simulation after some time
    end
endmodule
