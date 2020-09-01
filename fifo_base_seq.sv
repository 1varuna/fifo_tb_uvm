/*
* File: fifo_base_seq.sv
* Author: Varun Anand
* Description: Generator class which generates input transactions
* and puts it onto a mailbox for the master and slave driver. 
	*/

       class fifo_base_seq #(parameter FIFO_WIDTH=32, parameter FIFO_DEPTH=2**5) extends uvm_sequence #(fifo_seq_item);

	       // Register Sequence in UVM Factory
	       `uvm_object_param_utils(fifo_base_seq #(FIFO_WIDTH,FIFO_DEPTH))

       		function new(string name="fifo_base_seq");		// fifo_base_seq class constructor 
	       		super.new(name);
       		endfunction 

	       rand int num_data;			// Random number of data packets to be generated
		
	       constraint num_data_c{		// constraint on volume of data generation
		       num_data inside {
		       [25:FIFO_DEPTH]
	       };	
       }

       int mode_val = 1;			// Control randomization of trans rand variables
       string test = "rand";			// Default value - can be over written in test

       // Newly added for UVM
       virtual task body();		       // create, randomize and send seq_item
       		`uvm_info(get_type_name(),$sformatf("Value of num_data is %0d",num_data),UVM_LOW)
       		repeat(num_data) begin
			`uvm_do(req);		// Creates sequence item, randomizes it and sends to driver
		/*
       		req = fifo_seq_item#(FIFO_WIDTH)::type_id::create("req");		// req is the instantiation of the fifo_seq_item inherited from fifo_base_seq class
		assert(req.randomize());
		send_request(req);
		wait_for_item_done();
		*/
		end
       endtask

endclass
