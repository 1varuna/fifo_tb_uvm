/*
* File: test.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Test file which instantiates fifo_env class
* and calls the run method, which starts a randomized test.
*/

program test(fifo_intf intf);
	
	// declare an env object
	fifo_env #(.FIFO_WIDTH(`DEF_FIFO_WIDTH),.FIFO_DEPTH(`DEF_FIFO_DEPTH)) env;
	
	int num_data = $urandom_range(15,`DEF_FIFO_DEPTH);

	// Instantiate the environment object
	initial begin
		env = new(intf);
		env.gen.num_data = num_data;		// Overrides default value generated in gen
		env.run();
	end

endprogram
