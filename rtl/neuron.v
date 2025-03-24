`include "../rtl/pro_ele.v"
`include "../rtl/relu.v"


module neuron(

    //inputs
    input [31:0] w_node2neuron,
    input [31:0] x_node2neuron,
    input [31:0] b_node2neuron,
    input head_node2neuron,
    input clock_neuron_in,

    //outputs
    output reg [31:0] relu_out_neuron2node,
    output reg relu_done_neuron2node


);

    wire [31:0] pe_out_pe2relu;
    wire done_flag_pe2relu;

    pro_ele PRO_ELEMENT (.w(w_node2neuron),
                            .x_in(x_node2neuron),
                            .b(b_node2neuron),
                            .head(head_node2neuron),
                            .clock(clock_neuron_in),
                            .pe_out(pe_out_pe2relu),
                            .done_flag(done_flag_pe2relu)
                                            );

    relu RELU_IN (  .clock(clock_neuron_in),
                    .relu_in(pe_out_pe2relu),
                    .relu_valid(done_flag_pe2relu),
                    .relu_out(relu_out_neuron2node),
                    .relu_done(relu_done_neuron2node)
                                            );




endmodule