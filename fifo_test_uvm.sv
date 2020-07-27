/*
*	ADD File description
*/

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
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Test RUN phase",UVM_LOW)
		base_seq = fifo_base_seq#(`DEF_FIFO_WIDTH)::type_id::create("fifo_base_seq");
		
		phase.raise_objection(this);
		base_seq.start(env.fifo_ag.seqr);
		phase.drop_objection(this);
		
	endtask

endclass
