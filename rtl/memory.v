`timescale 1ns / 1ps

module memory_512kb (
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [13:0] addr, // 16K locations need 14-bit address
    input wire [31:0] data_in,
    output reg [31:0] data_out,
    output reg valid_out
);
    
    reg [31:0] memory [0:16383]; // 16K locations of 32-bit each
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            valid_out <= 0;
        end else begin
            if (wr_en) begin
                memory[addr] <= data_in;
            end
            if (rd_en) begin
                data_out <= memory[addr];
                valid_out <= 1;
            end else begin
                valid_out <= 0;
            end
        end
    end
endmodule
