/*
* File: write_read_test.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Test which generated writes followed by reads
*/

`ifndef WR_RD_TEST
`define WR_RD_TEST

program write_read_test(fifo_intf intf);

	// Declare env object
	fifo_env #(.FIFO_WIDTH(`DEF_FIFO_WIDTH),.FIFO_DEPTH(`DEF_FIFO_DEPTH)) env;

	int num_data = `DEF_FIFO_DEPTH+5;		// FORCES full signal after reaching FIFO_DEPTH

	// Instantiate the environment object
	initial begin
		env = new(intf);
		env.gen.num_data = num_data;		// Overrides default value generated in gen
		env.gen.mode_val = 0;			// Disable randomization
		env.gen.test = "write_read";		// Overrides default value generated in gen
		env.run();
	end

endprogram
`endif
