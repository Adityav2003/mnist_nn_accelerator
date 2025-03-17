`timescale 1ns / 1ps

module memory_512kb_tb;
    reg clk, rst, wr_en, rd_en;
    reg [13:0] addr;
    reg [31:0] data_in;
    wire [31:0] data_out;
    wire valid_out;

    memory_512kb uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    reg [31:0] mem_data [0:9]; // Array to store memory values
    integer i;

    always #5 clk = ~clk; // Clock generation (10ns period)

    initial begin
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        addr = 0;
        data_in = 0;
        #10 rst = 0;

        $display("\nNow reading:");

        // Read back values for verification
        for (i = 0; i < 10; i = i + 1) begin
            
            rd_en = 1;
            addr = i;
            #10; // Allow time for data to appear
            $display("Reading: Memory[%0d] = %h", addr, data_out);
            
        end
        rd_en = 0;

        

        $finish;
    end
endmodule
