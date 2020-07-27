/*
* File: fifo_input_mon.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Fifo Input Monitor class which helps
* monitor write request and input data into DUT. 
*/

// Uncomment below for standalone compile
//`include "fifo_seq_item.sv"
//`include "fifo_intf.sv"

class fifo_input_mon extends uvm_monitor;
	
	`uvm_component_utils(fifo_input_mon)	
	virtual fifo_intf fifo_vif;
	uvm_analysis_port ap;

	function new (string name,uvm_component parent);	// Class constructor
		super.new(name,parent);			// UVM Monitor - parent
	endfunction

	virtual function void build_phase(uvm_phase phase);	// *_phase() signature always accepts uvm_phase type as input
		super.build_phase(phase);
		if(!uvm_config_db #(virtual fifo_intf) :: get(this,"","fifo_intf",fifo_vif)) begin
			`uvm_fatal(get_type_name(),"Didn't get handle to Virtual IF fifo_vif")
		end
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			sample;
		end
	endtask

	task sample;
			fifo_seq_item trans;
			trans = new();

			@(posedge fifo_vif.clk);
			trans.wr_en = fifo_vif.wr_en;
			trans.data_in = fifo_vif.data_in;
			trans.rd_en = fifo_vif.rd_en;
			$display("\tINPUT MONITOR::sample() : Transaction info: wr_en = %0d, rd_en = %0d, data_in=%0d\n",trans.wr_en,trans.rd_en,trans.data_in);
			@(posedge fifo_vif.clk);
			ap.write(trans);
	endtask
endclass
