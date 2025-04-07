help: 
	@echo "Welcome to the simulation script_______________________________"
	@echo "run_top_module_sim - 		Runs the top simulation Module"
	@echo "run_pro_ele - 	 Runs the processing element simulation Module"
	@echo "run_main_mem -    		     Simulates the main memory"

run_top_module_sim:
	iverilog -o nn_accelerator_top_sim ../rtl/nn_accelerator_top.v ../tb/nn_accelerator_top_tb.v
	vvp nn_accelerator_top_sim
	gtkwave nn_accelerator_top_tb.vcd

run_pro_ele:
	iverilog -o pro_ele_sim ../rtl/pro_ele.v ../tb/pro_ele_tb.v
	vvp pro_ele_sim
	gtkwave proElement_tb.vcd

run_main_mem:
	iverilog -o main_memory_sim ../rtl/main_memory.v ../tb/main_memory_tb.v
	vvp main_memory_sim



