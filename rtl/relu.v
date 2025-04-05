module relu(
	input clock,
	input  [31:0] relu_in, //input for relu
	input relu_valid, //valid flag to enable relu calculation
	output reg [31:0] relu_out, //output for relu
	output reg relu_done // flag to show that the calculation is done
);

	always @(posedge clock) begin
		if(relu_valid) begin //this is not correct
			relu_done <= 1'b1;
			if(relu_in[31] == 1'b1) relu_out <= 0;
			else relu_out <= relu_in;

			
		end
	end

	
endmodule
