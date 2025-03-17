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

        // Load values from file into memory
        $readmemh("../read_files/test_mem.txt", mem_data);

        wr_en = 1;
        @(posedge clk);
        addr = 1;
        data_in = mem_data[1];
        $display("Reading: Memory[%0d] = %h", addr, data_in);

        @(posedge clk);

        addr = 2;
        data_in = mem_data[0];
        $display("Reading: Memory[%0d] = %h", addr, data_in);
        @(posedge clk);

        addr = 4;
        data_in = mem_data[4];
        $display("Reading: Memory[%0d] = %h", addr, data_in);
        @(posedge clk);

        addr = 0;
        data_in = mem_data[3];
        $display("Reading: Memory[%0d] = %h", addr, data_in);
        @(posedge clk);


        wr_en = 0;

        $display("\nNow reading:");

        // Read back values for verification
        for (i = 0; i < 10; i = i + 1) begin
            
            rd_en = 1;
            addr = i;
            //#10; // Allow time for data to appear
            $display("Reading: Memory[%0d] = %h", addr, data_out);
            @(posedge clk);
        end
        rd_en = 0;

        for (i = 0; i < 10; i = i + 1) begin
            @(posedge clk);
            
            //#10; // Allow time for data to appear
            $display("Reading: Memdata[%0d] = %h", i, mem_data[i]);
        end

        $finish;
    end
endmodule
