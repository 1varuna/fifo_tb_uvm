/*
* File: test.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Fifo env class which intantiates testench components
* like generator, master driver, slave driver and launches parallel
* threads for the run tasks in each of the classes.  
*/

`ifndef FIFO_ENV
`define FIFO_ENV

class fifo_env #(parameter FIFO_WIDTH = 32,parameter FIFO_DEPTH=32) extends uvm_env;

	`uvm_component_param_utils(fifo_env #(FIFO_WIDTH,FIFO_DEPTH))

	fifo_sb sb;								// Fifo Scoreboard
	fifo_agent fifo_ag;

	// User-defined class constructor

	function new (string name,uvm_component parent);	// Class constructor
		super.new(name,parent);			// UVM Env - parent
	endfunction

	virtual function void build_phase(uvm_phase phase);	// *_phase() signature always accepts uvm_phase type as input
		super.build_phase(phase);
		sb = fifo_sb#(FIFO_WIDTH,FIFO_DEPTH)::type_id::create("sb",this);	
		fifo_ag = fifo_agent::type_id::create("fifo_ag",this);
		//uvm_config_db #(int) :: set (this, "fifo_ag*", "is_active", 1);
      		fifo_ag.is_active = UVM_ACTIVE;	
	endfunction

	virtual function void connect_phase(uvm_phase phase);		// Connect sequencer and driver
		fifo_ag.in_mon.ap.connect(sb.in_mon_fifo.analysis_export);	
		fifo_ag.out_mon.ap.connect(sb.out_mon_fifo.analysis_export);	
	endfunction
	
endclass
`endif
