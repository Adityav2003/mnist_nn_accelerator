module controller(
input clock,
input rst,
input done_flag_node2c,
output reg head_c2node,
output reg [3:0] data_select_c2node,
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

reg [4:0] current_state, next_state;
//parameters for the layers

parameter IDLE = 5'd0;

parameter L1_IDLE = 5'd1;
parameter L1_S1_COMPUTE = 5'd2;
parameter L1_S1_STORE = 5'd3;

parameter L1_S2_COMPUTE = 5'd4;
parameter L1_S2_STORE = 5'd5;

parameter L1_S3_COMPUTE = 5'd6;
parameter L1_S3_STORE = 5'd7;

parameter L1_FINAL = 5'd8;

//layer 2

parameter L2_IDLE = 5'd9;
parameter L2_S1_COMPUTE = 5'd10;
parameter L2_S1_STORE = 5'd11;

parameter L2_S2_COMPUTE = 5'd12;
parameter L2_S2_STORE = 5'd13;
parameter L2_FINAL = 5'd14;

//layer 3

parameter L3_IDLE = 5'd15;
parameter L3_COMPUTE = 5'd16;
parameter L3_STORE = 5'd17;

//softmax

parameter SOFTMAX = 5'd18;

//comparing

parameter COMPARATOR = 5'd19;

//output image

parameter OUTPUT_IMAGE = 5'd20;



//flags for layer wise tasks completion
reg layer1_done;
reg layer2_done;
reg layer3_done;

//registers for counting 

reg [9:0] counter;

//state transition 

always @(posedge clock) begin
	if(rst) begin
		current_state <= IDLE;
		next_state <= IDLE;
		layer1_done <= 0;
		layer2_done <= 0;
		layer3_done <= 0;
		head_c2node <= 0; //header bit
		data_select_c2node <= 0;
		rd_en_c2mem <= 0;
		wr_en_c2mem <= 0;

		// all the address pointers are 0
		x_addr_c2mem <= 0;

		w1_addr_c2mem <= 0;
		w2_addr_c2mem <= 0;
		w3_addr_c2mem <= 0;
		w4_addr_c2mem <= 0;
		w5_addr_c2mem <= 0;
		w6_addr_c2mem <= 0;
		w7_addr_c2mem <= 0;
		w8_addr_c2mem <= 0;
		w9_addr_c2mem <= 0;
		w10_addr_c2mem <= 0;

		b1_addr_c2mem <= 0;
		b2_addr_c2mem <= 0;
		b3_addr_c2mem <= 0;
		b4_addr_c2mem <= 0;
		b5_addr_c2mem <= 0;
		b6_addr_c2mem <= 0;
		b7_addr_c2mem <= 0;
		b8_addr_c2mem <= 0;
		b9_addr_c2mem <= 0;
		b10_addr_c2mem <= 0;


	end
	else begin
		current_state <= next_state;
	end
end

//state computations
always @ (posedge clock)
begin
	case (current_state)
		
		IDLE : begin //0
			rd_en_c2mem = 1;
			head_c2node = 1;
			x_addr_c2mem = 16'h620a;
			next_state = L1_IDLE;
		end

		L1_IDLE : begin //1
			rd_en_c2mem = 1;
			head_c2node = 0;
			//if (done_flag_node2c == 0) begin

				

				//initializing the address pointers
				//x input
				x_addr_c2mem = 16'h5ec5;

				//weights

				w1_addr_c2mem = 16'h0001;
				w2_addr_c2mem = w1_addr_c2mem + 16'h000a;
				w3_addr_c2mem = w2_addr_c2mem + 16'h000a;
				w4_addr_c2mem = w3_addr_c2mem + 16'h000a;
				w5_addr_c2mem = w4_addr_c2mem + 16'h000a;
				w6_addr_c2mem = w5_addr_c2mem + 16'h000a;
				w7_addr_c2mem = w6_addr_c2mem + 16'h000a;
				w8_addr_c2mem = w7_addr_c2mem + 16'h000a;
				w9_addr_c2mem = w8_addr_c2mem + 16'h000a;
				w10_addr_c2mem = w9_addr_c2mem + 16'h000a;

				//biases

				b1_addr_c2mem = 16'h5e89;
				b2_addr_c2mem = b1_addr_c2mem + 16'h0001;
				b3_addr_c2mem = b2_addr_c2mem + 16'h0001;
				b4_addr_c2mem = b3_addr_c2mem + 16'h0001;
				b5_addr_c2mem = b4_addr_c2mem + 16'h0001;
				b6_addr_c2mem = b5_addr_c2mem + 16'h0001;
				b7_addr_c2mem = b6_addr_c2mem + 16'h0001;
				b8_addr_c2mem = b7_addr_c2mem + 16'h0001;
				b9_addr_c2mem = b8_addr_c2mem + 16'h0001;
				b10_addr_c2mem = b9_addr_c2mem + 16'h0001;

			//	counter = 0;

				next_state = L1_S1_COMPUTE;
			//end
			//else next_state = L1_IDLE;
		end

		L1_S1_COMPUTE : begin //2
			if(done_flag_node2c == 1) begin
				data_select_c2node = 0;
				next_state = L1_S1_STORE;
				x_addr_c2mem = 16'h61d5;
			end
			else begin 
				x_addr_c2mem = x_addr_c2mem + 1;

				w1_addr_c2mem = w1_addr_c2mem + 1;
				w2_addr_c2mem = w2_addr_c2mem + 1;
				w3_addr_c2mem = w3_addr_c2mem + 1;
				w4_addr_c2mem = w4_addr_c2mem + 1;
				w5_addr_c2mem = w5_addr_c2mem + 1;
				w6_addr_c2mem = w6_addr_c2mem + 1;
				w7_addr_c2mem = w7_addr_c2mem + 1;
				w8_addr_c2mem = w8_addr_c2mem + 1;
				w9_addr_c2mem = w9_addr_c2mem + 1;
				w10_addr_c2mem = w10_addr_c2mem + 1;
				next_state = L1_S1_COMPUTE;
			end
			
		end

		L1_S1_STORE : begin //3
			rd_en_c2mem = 0;
			wr_en_c2mem = 1;
			if(data_select_c2node == 4'b1010) begin
				data_select_c2node = 0;
				wr_en_c2mem = 0;
				rd_en_c2mem = 1;
				head_c2node = 1;
				x_addr_c2mem = 16'h620a;
				next_state = L1_S2_COMPUTE;
				
			end
			else begin
				data_select_c2node  = data_select_c2node + 1;
				x_addr_c2mem = x_addr_c2mem + 1;
			end
		end

		L1_S2_COMPUTE : begin //4
			head_c2node = 0;
			rd_en_c2mem = 1;
			wr_en_c2mem = 0;
			if(done_flag_node2c == 1) begin
				data_select_c2node = 0;
				next_state = L1_S2_STORE;
				x_addr_c2mem = 16'h61df; // to store the data
			end
			else begin
				x_addr_c2mem = x_addr_c2mem + 1;

				w1_addr_c2mem = w1_addr_c2mem + 1;
				w2_addr_c2mem = w2_addr_c2mem + 1;
				w3_addr_c2mem = w3_addr_c2mem + 1;
				w4_addr_c2mem = w4_addr_c2mem + 1;
				w5_addr_c2mem = w5_addr_c2mem + 1;
				w6_addr_c2mem = w6_addr_c2mem + 1;
				w7_addr_c2mem = w7_addr_c2mem + 1;
				w8_addr_c2mem = w8_addr_c2mem + 1;
				w9_addr_c2mem = w9_addr_c2mem + 1;
				w10_addr_c2mem = w10_addr_c2mem + 1;
				next_state = L1_S2_COMPUTE;
			end
		end

		L1_S2_STORE : begin //5
			rd_en_c2mem = 0;
			wr_en_c2mem = 1;
			if(data_select_c2node == 4'b1010) begin
				wr_en_c2mem = 0;
				rd_en_c2mem = 1;
				//head_c2node = 1;
				x_addr_c2mem = 16'h620a; //intializing the count
				next_state = L1_S3_COMPUTE;
				
			end
			else begin
				data_select_c2node  = data_select_c2node + 1;
				x_addr_c2mem = x_addr_c2mem + 1;
			end
		end

		L1_S3_COMPUTE : begin
			head_c2node = 0;
			rd_en_c2mem = 1;
			wr_en_c2mem = 0;
			if(done_flag_node2c == 1) begin
				data_select_c2node = 0;
				next_state = L1_S3_STORE;
				x_addr_c2mem = 16'h61e9; // to store the data
			end
			else begin 
				x_addr_c2mem = x_addr_c2mem + 1;

				w1_addr_c2mem = w1_addr_c2mem + 1;
				w2_addr_c2mem = w2_addr_c2mem + 1;
				w3_addr_c2mem = w3_addr_c2mem + 1;
				w4_addr_c2mem = w4_addr_c2mem + 1;
				w5_addr_c2mem = w5_addr_c2mem + 1;
				w6_addr_c2mem = w6_addr_c2mem + 1;
				w7_addr_c2mem = w7_addr_c2mem + 1;
				w8_addr_c2mem = w8_addr_c2mem + 1;
				w9_addr_c2mem = w9_addr_c2mem + 1;
				w10_addr_c2mem = w10_addr_c2mem + 1;
				next_state = L1_S3_COMPUTE;
			end
		end

		L1_S3_STORE : begin
			rd_en_c2mem = 0;
			wr_en_c2mem = 1;
			if(data_select_c2node == 4'b1010) begin
				wr_en_c2mem = 0;
				rd_en_c2mem = 1;
				head_c2node = 1;
				x_addr_c2mem = 16'h620a; //intializing the count
				next_state = L1_FINAL;
				
			end
			else begin
				data_select_c2node  = data_select_c2node + 1;
				x_addr_c2mem = x_addr_c2mem + 1;
			end
		end

		L1_FINAL : begin
			layer1_done = 1;
			x_addr_c2mem = 16'h620b;

			next_state = L2_IDLE;

		end

		L2_IDLE : begin
			rd_en_c2mem = 1;
			head_c2node = 0;
			//if (done_flag_node2c == 0) begin

				

				//initializing the address pointers
				//x input
				x_addr_c2mem = 16'h61d5;

				//weights

				w1_addr_c2mem = 16'h5be1;
				w2_addr_c2mem = w1_addr_c2mem + 16'h000a;
				w3_addr_c2mem = w2_addr_c2mem + 16'h000a;
				w4_addr_c2mem = w3_addr_c2mem + 16'h000a;
				w5_addr_c2mem = w4_addr_c2mem + 16'h000a;
				w6_addr_c2mem = w5_addr_c2mem + 16'h000a;
				w7_addr_c2mem = w6_addr_c2mem + 16'h000a;
				w8_addr_c2mem = w7_addr_c2mem + 16'h000a;
				w9_addr_c2mem = w8_addr_c2mem + 16'h000a;
				w10_addr_c2mem = w9_addr_c2mem + 16'h000a;

				//biases

				b1_addr_c2mem = 16'h5ea7;
				b2_addr_c2mem = b1_addr_c2mem + 16'h0001;
				b3_addr_c2mem = b2_addr_c2mem + 16'h0001;
				b4_addr_c2mem = b3_addr_c2mem + 16'h0001;
				b5_addr_c2mem = b4_addr_c2mem + 16'h0001;
				b6_addr_c2mem = b5_addr_c2mem + 16'h0001;
				b7_addr_c2mem = b6_addr_c2mem + 16'h0001;
				b8_addr_c2mem = b7_addr_c2mem + 16'h0001;
				b9_addr_c2mem = b8_addr_c2mem + 16'h0001;
				b10_addr_c2mem = b9_addr_c2mem + 16'h0001;

				//counter = 0;

				next_state = L2_S1_COMPUTE;
			//end
			//else next_state = L2_IDLE;
		end

		L2_S1_COMPUTE : begin
			head_c2node = 0;
			rd_en_c2mem = 1;
			wr_en_c2mem = 0;
			if(done_flag_node2c == 1) begin
				data_select_c2node = 0;
				next_state = L2_S1_STORE;
				x_addr_c2mem = 16'h61ef; // to store the data
			end
			else begin 
				x_addr_c2mem = x_addr_c2mem + 1;

				w1_addr_c2mem = w1_addr_c2mem + 1;
				w2_addr_c2mem = w2_addr_c2mem + 1;
				w3_addr_c2mem = w3_addr_c2mem + 1;
				w4_addr_c2mem = w4_addr_c2mem + 1;
				w5_addr_c2mem = w5_addr_c2mem + 1;
				w6_addr_c2mem = w6_addr_c2mem + 1;
				w7_addr_c2mem = w7_addr_c2mem + 1;
				w8_addr_c2mem = w8_addr_c2mem + 1;
				w9_addr_c2mem = w9_addr_c2mem + 1;
				w10_addr_c2mem = w10_addr_c2mem + 1;

				next_state = L2_S1_COMPUTE;
			end
		end

		L2_S1_STORE : begin
			rd_en_c2mem = 0;
			wr_en_c2mem = 1;
			if(data_select_c2node == 4'b1010) begin
				wr_en_c2mem = 0;
				rd_en_c2mem = 1;
				//head_c2node = 1;
				x_addr_c2mem = 16'h620b; //intializing the count 30
				next_state = L2_S2_COMPUTE;
				
			end
			else begin
				data_select_c2node  = data_select_c2node + 1;
				x_addr_c2mem = x_addr_c2mem + 1;
			end
		end

		L2_S2_COMPUTE : begin
			head_c2node = 0;
			rd_en_c2mem = 1;
			wr_en_c2mem = 0;
			if(done_flag_node2c == 1) begin
				data_select_c2node = 0;
				next_state = L2_S2_STORE;
				x_addr_c2mem = 16'h61f9; // to store the data
			end
			else begin 
				x_addr_c2mem = x_addr_c2mem + 1;

				w1_addr_c2mem = w1_addr_c2mem + 1;
				w2_addr_c2mem = w2_addr_c2mem + 1;
				w3_addr_c2mem = w3_addr_c2mem + 1;
				w4_addr_c2mem = w4_addr_c2mem + 1;
				w5_addr_c2mem = w5_addr_c2mem + 1;
				w6_addr_c2mem = w6_addr_c2mem + 1;
				w7_addr_c2mem = w7_addr_c2mem + 1;
				w8_addr_c2mem = w8_addr_c2mem + 1;
				w9_addr_c2mem = w9_addr_c2mem + 1;
				w10_addr_c2mem = w10_addr_c2mem + 1;

				next_state = L2_S2_COMPUTE;
			end
		end

		L2_S2_STORE : begin
			rd_en_c2mem = 0;
			wr_en_c2mem = 1;
			if(data_select_c2node == 4'b1010) begin
				wr_en_c2mem = 0;
				rd_en_c2mem = 1;
				head_c2node = 1;
				x_addr_c2mem = 16'h620c; //intializing the count 20
				next_state = L2_FINAL;
				
			end
			else begin
				data_select_c2node  = data_select_c2node + 1;
				x_addr_c2mem = x_addr_c2mem + 1;
			end
		end

		L2_FINAL : begin
			layer2_done = 1;
			x_addr_c2mem = 16'h620c;
			next_state = L3_IDLE;
		end

		L3_IDLE : begin
			rd_en_c2mem = 1;
			head_c2node = 0;
			//if (done_flag_node2c == 0) begin

				

				//initializing the address pointers
				//x input
				x_addr_c2mem = 16'h61ef;

				//weights

				w1_addr_c2mem = 16'h5de9;
				w2_addr_c2mem = w1_addr_c2mem + 16'h000a;
				w3_addr_c2mem = w2_addr_c2mem + 16'h000a;
				w4_addr_c2mem = w3_addr_c2mem + 16'h000a;
				w5_addr_c2mem = w4_addr_c2mem + 16'h000a;
				w6_addr_c2mem = w5_addr_c2mem + 16'h000a;
				w7_addr_c2mem = w6_addr_c2mem + 16'h000a;
				w8_addr_c2mem = w7_addr_c2mem + 16'h000a;
				w9_addr_c2mem = w8_addr_c2mem + 16'h000a;
				w10_addr_c2mem = w9_addr_c2mem + 16'h000a;

				//biases

				b1_addr_c2mem = 16'h5ea7;
				b2_addr_c2mem = b1_addr_c2mem + 16'h0001;
				b3_addr_c2mem = b2_addr_c2mem + 16'h0001;
				b4_addr_c2mem = b3_addr_c2mem + 16'h0001;
				b5_addr_c2mem = b4_addr_c2mem + 16'h0001;
				b6_addr_c2mem = b5_addr_c2mem + 16'h0001;
				b7_addr_c2mem = b6_addr_c2mem + 16'h0001;
				b8_addr_c2mem = b7_addr_c2mem + 16'h0001;
				b9_addr_c2mem = b8_addr_c2mem + 16'h0001;
				b10_addr_c2mem = b9_addr_c2mem + 16'h0001;

				counter = 0;

				next_state = L3_COMPUTE;
			//end
			//else next_state = L3_IDLE;
		end

		L3_COMPUTE : begin
			head_c2node = 0;
			rd_en_c2mem = 1;
			wr_en_c2mem = 0;
			if(done_flag_node2c == 1) begin
				data_select_c2node = 0;
				next_state = L3_STORE;
				x_addr_c2mem = 16'h61ff; // to store the data
			end
			else begin 
				x_addr_c2mem = x_addr_c2mem + 1;

				w1_addr_c2mem = w1_addr_c2mem + 1;
				w2_addr_c2mem = w2_addr_c2mem + 1;
				w3_addr_c2mem = w3_addr_c2mem + 1;
				w4_addr_c2mem = w4_addr_c2mem + 1;
				w5_addr_c2mem = w5_addr_c2mem + 1;
				w6_addr_c2mem = w6_addr_c2mem + 1;
				w7_addr_c2mem = w7_addr_c2mem + 1;
				w8_addr_c2mem = w8_addr_c2mem + 1;
				w9_addr_c2mem = w9_addr_c2mem + 1;
				w10_addr_c2mem = w10_addr_c2mem + 1;

				next_state = L3_COMPUTE;
			end

		end

		L3_STORE : begin
			rd_en_c2mem = 0;
			wr_en_c2mem = 1;
			if(data_select_c2node == 4'b1010) begin
				wr_en_c2mem = 0;
				rd_en_c2mem = 1;
				//head_c2node = 1;
				x_addr_c2mem = 16'h620d; //intializing the count 20
				next_state = SOFTMAX;
				
			end
			else begin
				data_select_c2node  = data_select_c2node + 1;
				x_addr_c2mem = x_addr_c2mem + 1;
			end
		end

		SOFTMAX : begin
			next_state = COMPARATOR;
		end

		COMPARATOR : begin
			next_state = OUTPUT_IMAGE;
		end

		OUTPUT_IMAGE : begin
			next_state = IDLE;
		end




	endcase
end

endmodule

