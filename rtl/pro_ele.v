// Created: February 22, 2025
// Author - Aditya Vikram Singh

`include "IEEE_754_adder.v"
`include "IEEE_754_multiplier.v"

module proElement(
	input w [31:0], //weights
	input x [31:0], // input
	input b [31:0], // base

	input count [9:0], //counter for operation

	input head, //header
	input clock,

	output pe_out [31:0], // output of processing element
	output done_flag //flag when operations are done
);

// when the head is HIGH then the x cointains the count of iterations of size

reg [9:0] final_count; // the final count till the counter counts MOD - N
reg [9:0] count;

//intermediate values
reg [31:0] i_w;
reg [31:0] i_x;
reg [31:0] i_b;

reg [31:0] accum; //accumulator which contains intermediate count
reg [31:0] add_p; //accumulator for each iteration
wire [31:0] add_n; //accumulator after multiplication
wire [31:0] accum_w;

always @(posedge clk)begin
	i_w = w;
	i_x = x;
	i_b = b;
	if(head)begin
		final_count = x[9:0]; // when the header is high then the x[9:0] contains the final count of the PE
		add_p = 0;
		accum = 0;
	end

	if(count == final_count - 1'b1)begin
		accum = accum + b;
		pe_out = accum;
	end
	else begin
		fp32_multiplier MULT(i_w, i_x, add_n);
	      	IEEE_754_adder ADDR(add_p, add_n, accum_w);
		accum = accum_w;
	 	add_p = accum;
		count = count + 1'b1;	
	end

end

endmodule
