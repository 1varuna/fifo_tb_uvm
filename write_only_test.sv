/*
* File: write_only_test.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Test which generated only writes and check if
	full is asserted when fifo depth is reached
*/

`ifndef WR_ONLY_TEST
`define WR_ONLY_TEST

program write_only_test(fifo_intf intf);

	// Declare env object
	fifo_env #(.FIFO_WIDTH(`DEF_FIFO_WIDTH),.FIFO_DEPTH(`DEF_FIFO_DEPTH)) env;

	int num_data = `DEF_FIFO_DEPTH+5;		// FORCES full signal after reaching FIFO_DEPTH

	// Instantiate the environment object
	initial begin
		env = new(intf);
		env.gen.num_data = num_data;		// Overrides default value generated in gen
		env.gen.mode_val = 0;			// Disable randomization
		env.gen.test = "write_only";		// Overrides default value generated in gen
		env.run();
	end

endprogram
`endif
