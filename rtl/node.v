`include "../rtl/neuron.v"

module node(
    //inputs
    input head_c2node, //head activate
    input clock_node_in,
    
    input wire [31:0] x_mem2node, //input node

    //weights
    input wire [31:0] w1_mem2node, 
    input wire [31:0] w2_mem2node, 
    input wire [31:0] w3_mem2node, 
    input wire [31:0] w4_mem2node, 
    input wire [31:0] w5_mem2node, 
    input wire [31:0] w6_mem2node, 
    input wire [31:0] w7_mem2node, 
    input wire [31:0] w8_mem2node, 
    input wire [31:0] w9_mem2node, 
    input wire [31:0] w10_mem2node, 

    //bias
    //weights
    input wire [31:0] b1_mem2node, 
    input wire [31:0] b2_mem2node, 
    input wire [31:0] b3_mem2node, 
    input wire [31:0] b4_mem2node, 
    input wire [31:0] b5_mem2node, 
    input wire [31:0] b6_mem2node, 
    input wire [31:0] b7_mem2node, 
    input wire [31:0] b8_mem2node, 
    input wire [31:0] b9_mem2node, 
    input wire [31:0] b10_mem2node, 

    //mux selector
    input wire [3:0] data_sel_c2node,

    //outputs

    output reg [31:0] data_node2mem,
    output done_flag_node2c

);

    wire d1,d2,d3,d4,d5,d6,d7,d8,d9,d10;

    wire [31:0] w1;
    wire [31:0] w2;
    wire [31:0] w3;
    wire [31:0] w4;
    wire [31:0] w5;
    wire [31:0] w6;
    wire [31:0] w7;
    wire [31:0] w8;
    wire [31:0] w9;
    wire [31:0] w10;
    
    


    neuron N1 (.w_node2neuron(w1_mem2node),
                .x_node2neuron(x_mem2node),
                .b_node2neuron(b1_mem2node),
                .head_node2neuron(head_c2node),
                .clock_neuron_in(clock_node_in),
                .relu_out_neuron2node(w1),
                .relu_done_neuron2node(d1)
                                            );

    neuron N2 (.w_node2neuron(w2_mem2node),
                .x_node2neuron(x_mem2node),
                .b_node2neuron(b2_mem2node),
                .head_node2neuron(head_c2node),
                .clock_neuron_in(clock_node_in),
                .relu_out_neuron2node(w2),
                .relu_done_neuron2node(d2)
                                            );

    neuron N3 (.w_node2neuron(w3_mem2node),
                .x_node2neuron(x_mem2node),
                .b_node2neuron(b3_mem2node),
                .head_node2neuron(head_c2node),
                .clock_neuron_in(clock_node_in),
                .relu_out_neuron2node(w3),
                .relu_done_neuron2node(d3)
                                            );

    neuron N4 (.w_node2neuron(w4_mem2node),
                .x_node2neuron(x_mem2node),
                .b_node2neuron(b4_mem2node),
                .head_node2neuron(head_c2node),
                .clock_neuron_in(clock_node_in),
                .relu_out_neuron2node(w4),
                .relu_done_neuron2node(d4)
                                            );

    neuron N5 (.w_node2neuron(w5_mem2node),
                .x_node2neuron(x_mem2node),
                .b_node2neuron(b5_mem2node),
                .head_node2neuron(head_c2node),
                .clock_neuron_in(clock_node_in),
                .relu_out_neuron2node(w5),
                .relu_done_neuron2node(d5)
                                            );

    neuron N6 (.w_node2neuron(w6_mem2node),
                .x_node2neuron(x_mem2node),
                .b_node2neuron(b6_mem2node),
                .head_node2neuron(head_c2node),
                .clock_neuron_in(clock_node_in),
                .relu_out_neuron2node(w6),
                .relu_done_neuron2node(d6)
                                            );

    neuron N7 (.w_node2neuron(w7_mem2node),
                .x_node2neuron(x_mem2node),
                .b_node2neuron(b7_mem2node),
                .head_node2neuron(head_c2node),
                .clock_neuron_in(clock_node_in),
                .relu_out_neuron2node(w7),
                .relu_done_neuron2node(d7)
                                            );

    neuron N8 (.w_node2neuron(w8_mem2node),
                .x_node2neuron(x_mem2node),
                .b_node2neuron(b8_mem2node),
                .head_node2neuron(head_c2node),
                .clock_neuron_in(clock_node_in),
                .relu_out_neuron2node(w8),
                .relu_done_neuron2node(d8)
                                            );

    neuron N9 (.w_node2neuron(w9_mem2node),
                .x_node2neuron(x_mem2node),
                .b_node2neuron(b9_mem2node),
                .head_node2neuron(head_c2node),
                .clock_neuron_in(clock_node_in),
                .relu_out_neuron2node(w9),
                .relu_done_neuron2node(d9)
                                            );

    neuron N10 (.w_node2neuron(w10_mem2node),
                .x_node2neuron(x_mem2node),
                .b_node2neuron(b10_mem2node),
                .head_node2neuron(head_c2node),
                .clock_neuron_in(clock_node_in),
                .relu_out_neuron2node(w10),
                .relu_done_neuron2node(d10)
                                            );


    always @(posedge clock_node_in) begin
        case (data_sel_c2node)
            4'b0000 : data_node2mem <= w1;
            4'b0001 : data_node2mem <= w2;
            4'b0010 : data_node2mem <= w3;
            4'b0011 : data_node2mem <= w4;
            4'b0100 : data_node2mem <= w5;
            4'b0101 : data_node2mem <= w6;
            4'b0110 : data_node2mem <= w7;
            4'b0111 : data_node2mem <= w8;
            4'b1000 : data_node2mem <= w9;
            4'b1001 : data_node2mem <= w10;

            default: data_node2mem <= 0;
        endcase
    end

    assign done_flag_node2c = d1 & d2 & d3 & d4 & d5 & d6 & d7 & d8& d9& d10;
                                           



endmodule