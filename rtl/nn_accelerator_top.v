`timescale 1ns / 1ps
`include "../rtl/controller.v"
`include "../rtl/main_memory.v"
`include "../rtl/node.v"

module nn_accelerator_top(
    input clock,
    input rst,
    input hard_rst,
    output [31:0] values
);

    // Control signals
    wire head_c2node;
    wire [3:0] data_select_c2node;
    wire rd_en_c2mem;
    wire wr_en_c2mem;
    wire done_flag_node2c;
    wire [31:0] wr_data;

    // Address wires
    wire [15:0] x_addr_c2mem;
    wire [15:0] w1_addr_c2mem, w2_addr_c2mem, w3_addr_c2mem, w4_addr_c2mem, w5_addr_c2mem;
    wire [15:0] w6_addr_c2mem, w7_addr_c2mem, w8_addr_c2mem, w9_addr_c2mem, w10_addr_c2mem;
    wire [15:0] b1_addr_c2mem, b2_addr_c2mem, b3_addr_c2mem, b4_addr_c2mem, b5_addr_c2mem;
    wire [15:0] b6_addr_c2mem, b7_addr_c2mem, b8_addr_c2mem, b9_addr_c2mem, b10_addr_c2mem;

    // Data wires
    wire [31:0] x_data;
    wire [31:0] w1_data, w2_data, w3_data, w4_data, w5_data;
    wire [31:0] w6_data, w7_data, w8_data, w9_data, w10_data;
    wire [31:0] b1_data, b2_data, b3_data, b4_data, b5_data;
    wire [31:0] b6_data, b7_data, b8_data, b9_data, b10_data;
    
    // Controller instantiation
    controller CONT (
        .clock(clock),
        .rst(rst),
        .done_flag_node2c(done_flag_node2c),
        .head_c2node(head_c2node),
        .data_select_c2node(data_select_c2node),
        .rd_en_c2mem(rd_en_c2mem),
        .wr_en_c2mem(wr_en_c2mem),
        .x_addr_c2mem(x_addr_c2mem),
        .w1_addr_c2mem(w1_addr_c2mem), .w2_addr_c2mem(w2_addr_c2mem), .w3_addr_c2mem(w3_addr_c2mem),
        .w4_addr_c2mem(w4_addr_c2mem), .w5_addr_c2mem(w5_addr_c2mem), .w6_addr_c2mem(w6_addr_c2mem),
        .w7_addr_c2mem(w7_addr_c2mem), .w8_addr_c2mem(w8_addr_c2mem), .w9_addr_c2mem(w9_addr_c2mem),
        .w10_addr_c2mem(w10_addr_c2mem),
        .b1_addr_c2mem(b1_addr_c2mem), .b2_addr_c2mem(b2_addr_c2mem), .b3_addr_c2mem(b3_addr_c2mem),
        .b4_addr_c2mem(b4_addr_c2mem), .b5_addr_c2mem(b5_addr_c2mem), .b6_addr_c2mem(b6_addr_c2mem),
        .b7_addr_c2mem(b7_addr_c2mem), .b8_addr_c2mem(b8_addr_c2mem), .b9_addr_c2mem(b9_addr_c2mem),
        .b10_addr_c2mem(b10_addr_c2mem)
    );

    // Main Memory Instantiation
    main_memory_32k_x_32bit MEM (
        .rst(hard_rst),
        .clock_mem(clock),
        .rd_en(rd_en_c2mem),
        .wr_en(wr_en_c2mem),
        .wr_data(wr_data),  // Default data for now
        .x_addr(x_addr_c2mem),
        .w1_addr(w1_addr_c2mem), .w2_addr(w2_addr_c2mem), .w3_addr(w3_addr_c2mem),
        .w4_addr(w4_addr_c2mem), .w5_addr(w5_addr_c2mem), .w6_addr(w6_addr_c2mem),
        .w7_addr(w7_addr_c2mem), .w8_addr(w8_addr_c2mem), .w9_addr(w9_addr_c2mem),
        .w10_addr(w10_addr_c2mem),
        .b1_addr(b1_addr_c2mem), .b2_addr(b2_addr_c2mem), .b3_addr(b3_addr_c2mem),
        .b4_addr(b4_addr_c2mem), .b5_addr(b5_addr_c2mem), .b6_addr(b6_addr_c2mem),
        .b7_addr(b7_addr_c2mem), .b8_addr(b8_addr_c2mem), .b9_addr(b9_addr_c2mem),
        .b10_addr(b10_addr_c2mem),
        .x_data(x_data),
        .w1_data(w1_data), .w2_data(w2_data), .w3_data(w3_data), .w4_data(w4_data), .w5_data(w5_data),
        .w6_data(w6_data), .w7_data(w7_data), .w8_data(w8_data), .w9_data(w9_data), .w10_data(w10_data),
        .b1_data(b1_data), .b2_data(b2_data), .b3_data(b3_data), .b4_data(b4_data), .b5_data(b5_data),
        .b6_data(b6_data), .b7_data(b7_data), .b8_data(b8_data), .b9_data(b9_data), .b10_data(b10_data)
    );

    // // Neuron Instantiation
    // neuron NEUR (
    //     .w_node2neuron(w1_data), // Example: using w1_data as input weight
    //     .x_node2neuron(x_data),  // Using x_data as input
    //     .b_node2neuron(b1_data), // Using b1_data as bias
    //     .head_node2neuron(head_c2node),
    //     .clock_neuron_in(clock),
    //     .relu_out_neuron2node(values), // Output connected to top module
    //     .relu_done_neuron2node(done_flag_node2c) // Done flag for controller
    // );

    node NODE(
    //inputs
    .head_c2node(head_c2node), //head activate
    .clock_node_in(clock),
    
    .x_mem2node(x_data), //input node

    //weights
    .w1_mem2node(w1_data), 
    .w2_mem2node(w2_data), 
    .w3_mem2node(w3_data), 
    .w4_mem2node(w4_data), 
    .w5_mem2node(w5_data), 
    .w6_mem2node(w6_data), 
    .w7_mem2node(w7_data), 
    .w8_mem2node(w8_data), 
    .w9_mem2node(w9_data), 
    .w10_mem2node(w10_data), 

    //bias
    //weights
    .b1_mem2node(b1_data), 
    .b2_mem2node(b2_data), 
    .b3_mem2node(b3_data), 
    .b4_mem2node(b4_data), 
    .b5_mem2node(b5_data), 
    .b6_mem2node(b6_data), 
    .b7_mem2node(b7_data), 
    .b8_mem2node(b8_data), 
    .b9_mem2node(b9_data), 
    .b10_mem2node(b10_data), 

    //mux selector
    .data_sel_c2node(data_select_c2node),

    //outputs

    .data_node2mem(wr_data),
    .done_flag_node2c(done_flag_node2c)

    );


endmodule
