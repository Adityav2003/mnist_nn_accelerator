`timescale 1ns / 1ps

module main_memory_32k_x_32bit(
    input rst,
    input clock_mem,

    input rd_en,
    input wr_en,
    input [31:0] wr_data,

    // Address pointers
    input [15:0] x_addr,

    input [15:0] w1_addr,
    input [15:0] w2_addr,
    input [15:0] w3_addr,
    input [15:0] w4_addr,
    input [15:0] w5_addr,
    input [15:0] w6_addr,
    input [15:0] w7_addr,
    input [15:0] w8_addr,
    input [15:0] w9_addr,
    input [15:0] w10_addr,

    input [15:0] b1_addr,
    input [15:0] b2_addr,
    input [15:0] b3_addr,
    input [15:0] b4_addr,
    input [15:0] b5_addr,
    input [15:0] b6_addr,
    input [15:0] b7_addr,
    input [15:0] b8_addr,
    input [15:0] b9_addr,
    input [15:0] b10_addr,

    // Outputs
    output reg [31:0] x_data,

    output reg [31:0] w1_data,
    output reg [31:0] w2_data,
    output reg [31:0] w3_data,
    output reg [31:0] w4_data,
    output reg [31:0] w5_data,
    output reg [31:0] w6_data,
    output reg [31:0] w7_data,
    output reg [31:0] w8_data,
    output reg [31:0] w9_data,
    output reg [31:0] w10_data,
    
    output reg [31:0] b1_data,
    output reg [31:0] b2_data,
    output reg [31:0] b3_data,
    output reg [31:0] b4_data,
    output reg [31:0] b5_data,
    output reg [31:0] b6_data,
    output reg [31:0] b7_data,
    output reg [31:0] b8_data,
    output reg [31:0] b9_data,
    output reg [31:0] b10_data
);

    // Memory array: 32KB (8K x 32-bit)
    reg [31:0] memory [0:32767];
    integer i;

    initial begin
        $readmemh("../read_files/weights_biases_inp.hex", memory);
    end

    always @(posedge clock_mem) begin
        if (rst) begin
            // Reset all memory and outputs to zero
            
            for (i = 0; i < 32767; i = i + 1) begin
                memory[i] <= 32'd0;
            end
            x_data  <= 32'd0;
            w1_data <= 32'd0;
            w2_data <= 32'd0;
            w3_data <= 32'd0;
            w4_data <= 32'd0;
            w5_data <= 32'd0;
            w6_data <= 32'd0;
            w7_data <= 32'd0;
            w8_data <= 32'd0;
            w9_data <= 32'd0;
            w10_data <= 32'd0;
            b1_data <= 32'd0;
            b2_data <= 32'd0;
            b3_data <= 32'd0;
            b4_data <= 32'd0;
            b5_data <= 32'd0;
            b6_data <= 32'd0;
            b7_data <= 32'd0;
            b8_data <= 32'd0;
            b9_data <= 32'd0;
            b10_data <= 32'd0;
        end else if (wr_en) begin
            // Write operation
            memory[x_addr] <= wr_data;
        end else if (rd_en) begin
            // Read operation
            x_data  <= memory[x_addr];
            
            w1_data <= memory[w1_addr];
            w2_data <= memory[w2_addr];
            w3_data <= memory[w3_addr];
            w4_data <= memory[w4_addr];
            w5_data <= memory[w5_addr];
            w6_data <= memory[w6_addr];
            w7_data <= memory[w7_addr];
            w8_data <= memory[w8_addr];
            w9_data <= memory[w9_addr];
            w10_data <= memory[w10_addr];

            b1_data <= memory[b1_addr];
            b2_data <= memory[b2_addr];
            b3_data <= memory[b3_addr];
            b4_data <= memory[b4_addr];
            b5_data <= memory[b5_addr];
            b6_data <= memory[b6_addr];
            b7_data <= memory[b7_addr];
            b8_data <= memory[b8_addr];
            b9_data <= memory[b9_addr];
            b10_data <= memory[b10_addr];
        end
    end

endmodule
