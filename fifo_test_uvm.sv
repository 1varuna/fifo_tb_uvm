/*
* File : fifo_test_uvm.sv
* Author : Varun Anand
* Description: UVM test class.
*/

`ifndef FIFO_TEST_UVM
`define FIFO_TEST_UVM
class fifo_test_uvm extends uvm_test;
	
	`uvm_component_utils(fifo_test_uvm)

	fifo_env #(.FIFO_WIDTH(`DEF_FIFO_WIDTH),.FIFO_DEPTH(`DEF_FIFO_DEPTH)) env;	// Fifo Env 
	fifo_base_seq #(.FIFO_WIDTH(`DEF_FIFO_WIDTH),.FIFO_DEPTH(`DEF_FIFO_DEPTH)) base_seq;	// Fifo Generator

	function new (string name,uvm_component parent);	// Class constructor
		super.new(name,parent);			// UVM Test - parent
	endfunction

	virtual function void build_phase(uvm_phase phase);	// *_phase() signature always accepts uvm_phase type as input
		super.build_phase(phase);
		env = fifo_env#(`DEF_FIFO_WIDTH,`DEF_FIFO_DEPTH)::type_id::create("fifo_env",this);
		// base_seq need not be created here	
	endfunction
	
	virtual function void end_of_elaboration_phase (uvm_phase phase);
      	uvm_top.print_topology ();
   	endfunction
	
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Test RUN phase",UVM_LOW)
		`uvm_info(get_type_name(),"Before Creating base seq",UVM_LOW)
		base_seq = fifo_base_seq#(`DEF_FIFO_WIDTH)::type_id::create("fifo_base_seq");
		`uvm_info(get_type_name(),"Created a base sequence here",UVM_LOW)
		base_seq.randomize();	
		phase.raise_objection(this);		// IMPORTANT :
		`uvm_info(get_type_name(),"Before Starting Sequence",UVM_LOW)
		base_seq.start(env.fifo_ag.seqr);
		phase.drop_objection(this);		// IMPORTANT
		`uvm_info(get_type_name(),"After dropping objection",UVM_LOW)		
	endtask

endclass
`endif
