/*
*	Add file decription
*/

class fifo_agent extends uvm_agent;
	`uvm_component_utils(fifo_agent)
	
	fifo_drv drv;								// Fifo Master Driver
	fifo_slv_drv slv_drv;							// Fifo slave driver
	uvm_sequencer #(fifo_seq_item) seqr;
	fifo_input_mon in_mon;							// Input monitor
	fifo_output_mon out_mon;						// Output monitor
	
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);	// build components
		super.build_phase(phase);

		if(get_is_active()) begin	// checks if UVM_ACTIVE is set i.e, Agent is ACTIVE (Other option: Passive agent)
		// build sequencer, driver and monitor classes using "create"
		drv = fifo_drv::type_id::create("drv",this);
		seqr = uvm_sequencer#(fifo_seq_item)::type_id::create("seqr",this);
		//slv_drv = fifo_slv_drv::type_id::create("slv_drv",this);
		end

		in_mon = fifo_input_mon::type_id::create("in_mon",this);
		out_mon = fifo_output_mon::type_id::create("out_mon",this);

	endfunction

	virtual function void connect_phase(uvm_phase phase);		// Connect sequencer and driver
		if(get_is_active())
		begin
			drv.seq_item_port.connect(seqr.seq_item_export);	
		end
	endfunction



endclass
