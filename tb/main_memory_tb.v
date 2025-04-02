`timescale 1ns / 1ps

module main_memory_32k_x_32bit_tb;
    reg rst;
    reg clock_mem;
    reg rd_en;
    reg wr_en;
    reg [31:0] wr_data;
    reg [15:0] x_addr;
    reg [15:0] w1_addr;
    reg [15:0] w2_addr;
    reg [15:0] w3_addr;
    reg [15:0] w4_addr;
    reg [15:0] w5_addr;
    reg [15:0] w6_addr;
    reg [15:0] w7_addr;
    reg [15:0] w8_addr;
    reg [15:0] w9_addr;
    reg [15:0] w10_addr;
    reg [15:0] b1_addr;
    reg [15:0] b2_addr;
    reg [15:0] b3_addr;
    reg [15:0] b4_addr;
    reg [15:0] b5_addr;
    reg [15:0] b6_addr;
    reg [15:0] b7_addr;
    reg [15:0] b8_addr;
    reg [15:0] b9_addr;
    reg [15:0] b10_addr;
    
    wire [31:0] x_data;
    wire [31:0] w1_data;
    wire [31:0] w2_data;
    wire [31:0] w3_data;
    wire [31:0] w4_data;
    wire [31:0] w5_data;
    wire [31:0] w6_data;
    wire [31:0] w7_data;
    wire [31:0] w8_data;
    wire [31:0] w9_data;
    wire [31:0] w10_data;
    wire [31:0] b1_data;
    wire [31:0] b2_data;
    wire [31:0] b3_data;
    wire [31:0] b4_data;
    wire [31:0] b5_data;
    wire [31:0] b6_data;
    wire [31:0] b7_data;
    wire [31:0] b8_data;
    wire [31:0] b9_data;
    wire [31:0] b10_data;
    
    // Instantiate the DUT
    main_memory_32k_x_32bit uut (
        .rst(rst),
        .clock_mem(clock_mem),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .x_addr(x_addr),
        .w1_addr(w1_addr),
        .w2_addr(w2_addr),
        .w3_addr(w3_addr),
        .w4_addr(w4_addr),
        .w5_addr(w5_addr),
        .w6_addr(w6_addr),
        .w7_addr(w7_addr),
        .w8_addr(w8_addr),
        .w9_addr(w9_addr),
        .w10_addr(w10_addr),
        .b1_addr(b1_addr),
        .b2_addr(b2_addr),
        .b3_addr(b3_addr),
        .b4_addr(b4_addr),
        .b5_addr(b5_addr),
        .b6_addr(b6_addr),
        .b7_addr(b7_addr),
        .b8_addr(b8_addr),
        .b9_addr(b9_addr),
        .b10_addr(b10_addr),
        .x_data(x_data),
        .w1_data(w1_data),
        .w2_data(w2_data),
        .w3_data(w3_data),
        .w4_data(w4_data),
        .w5_data(w5_data),
        .w6_data(w6_data),
        .w7_data(w7_data),
        .w8_data(w8_data),
        .w9_data(w9_data),
        .w10_data(w10_data),
        .b1_data(b1_data),
        .b2_data(b2_data),
        .b3_data(b3_data),
        .b4_data(b4_data),
        .b5_data(b5_data),
        .b6_data(b6_data),
        .b7_data(b7_data),
        .b8_data(b8_data),
        .b9_data(b9_data),
        .b10_data(b10_data)
    );
    
    // Clock generation
    always #5 clock_mem = ~clock_mem;
    
    initial begin
        // Initialize inputs
        clock_mem = 0;
        rst = 0;
        rd_en = 0;
        wr_en = 0;
        wr_data = 0;
        x_addr = 0;
        w1_addr = 0;
        w2_addr = 0;
        w3_addr = 0;
        w4_addr = 0;
        w5_addr = 0;
        w6_addr = 0;
        w7_addr = 0;
        w8_addr = 0;
        w9_addr = 0;
        w10_addr = 0;
        b1_addr = 0;
        b2_addr = 0;
        b3_addr = 0;
        b4_addr = 0;
        b5_addr = 0;
        b6_addr = 0;
        b7_addr = 0;
        b8_addr = 0;
        b9_addr = 0;
        b10_addr = 0;
        
        // Reset sequence
        //#10 rst = 0;
        
        // Write data to memory
        #10 wr_en = 1; wr_data = 32'hA5A5A5A5; x_addr = 16'h0001;
        #10 wr_en = 0;
        
        // Read data from memory
        #10 rd_en = 1; x_addr = 16'h0001;
        #10 rd_en = 0;
        
        // Check if data is correctly read
        #10 if (x_data !== 32'hA5A5A5A5) begin
                $display("Memory data = %h, Memory addr = %h", x_data, x_addr);
                $display("Test failed: Read data mismatch");
            end
            else begin
                $display("Memory data = %h, Memory addr = %h", x_data, x_addr);
                $display("Test passed: Read data matched");
            end

        #10 rd_en = 1; x_addr = 16'h2a5b;
        #10 rd_en = 0;
        
        #10 if (x_data !== 32'hA5A5A111) begin
                $display("Memory data = %h, Memory addr = %h", x_data, x_addr);
                $display("Test failed: Read data mismatch");
        end
            else begin
                $display("Memory data = %h, Memory addr = %h", x_data, x_addr);
                $display("Test passed: Read data matched");
            end
        #10 $finish;
    end
endmodule
