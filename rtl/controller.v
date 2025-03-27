module controller(
input clock,
input rst,
input done_flag_node2c,
output reg head_c2node,
output reg data_select_c2node,
output reg rd_en_c2mem,

output reg wr_en_c2mem,

output reg [15:0] x_addr_c2mem,
output reg [15:0] w1_addr_c2mem,
output reg [15:0] w2_addr_c2mem,
output reg [15:0] w3_addr_c2mem,
output reg [15:0] w4_addr_c2mem,
output reg [15:0] w5_addr_c2mem,
output reg [15:0] w6_addr_c2mem,
output reg [15:0] w7_addr_c2mem,
output reg [15:0] w8_addr_c2mem,
output reg [15:0] w9_addr_c2mem,
output reg [15:0] w10_addr_c2mem,

output reg [15:0] b1_addr_c2mem,
output reg [15:0] b2_addr_c2mem,
output reg [15:0] b3_addr_c2mem,
output reg [15:0] b4_addr_c2mem,
output reg [15:0] b5_addr_c2mem,
output reg [15:0] b6_addr_c2mem,
output reg [15:0] b7_addr_c2mem,
output reg [15:0] b8_addr_c2mem,
output reg [15:0] b9_addr_c2mem,
output reg [15:0] b10_addr_c2mem
);

reg [1:0] current_state, next_state;
parameter IDLE = 3'b000, Layer1 = 3'b001, Layer2 = 3'b010, Layer3 = 3'b011,Display = 3'b100;

//flags for layer wise tasks completion
reg layer1_done;
reg layer2_done;
reg layer3_done;

//state transition 
always @(posedge clock)
begin
	if (rst) current_state <= IDLE;
	else current_state <= next_state;
end

//state computations
always @ (current_state)
begin
	case (current_state)
		IDLE: begin //000
		        layer1_done = 1'b0;
			layer2_done = 1'b0;
			layer3_done = 1'b0;
			if (rst) next_state = IDLE;
			else next_state = Layer1;
		end
	        Layer1: begin //0001
		        if (rst) next_state = IDLE;
			else if (layer1_done == 0) begin
				next_state = Layer1;
			end
			else if (layer1_done == 1)begin
				next_state = Layer2;
			end
		Layer2: begin //010
		        if (rst) next_state = IDLE;
			else if (layer2_done == 0) begin
				next_state = Layer2;
			end
			else if (layer2_done == 1) begin
				next_state = layer2;
			end
		Layer3: begin //011
		        if (rst) next_state = IDLE;
			else if (layer3_done == 0) begin
				next_state = Layer3;
			end
			else if (layer3_done == 1) begin
				next_state = Display;
			end
		Display:begin //100
		        if (rst) next_state = IDLE;
			else next_state = Display;
			end
		default: next_state = IDLE;
	endcase
end

























endmodule

