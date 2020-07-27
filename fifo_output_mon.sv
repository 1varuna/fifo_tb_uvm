/*
* File: fifo_output_mon.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Fifo Output Monitor class which helps
* monitor read request and output data from DUT. 
*/

// Uncomment below for standalone compile
//`include "fifo_seq_item.sv"
//`include "fifo_intf.sv"

class fifo_output_mon extends uvm_monitor;
	
	`uvm_component_utils(fifo_output_mon)	
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
			trans.rd_en = fifo_vif.rd_en;
			trans.data_out = fifo_vif.data_out;
			trans.full = fifo_vif.full;
			trans.empty = fifo_vif.empty;
			$display("\tOUTPUT MONITOR::sample() : Transaction info: wr_en = %0d, rd_en = %0d, data_out=%0d, full : %0d, empty: %0d\n",trans.wr_en,trans.rd_en,trans.data_out,trans.full,trans.empty);
			@(posedge fifo_vif.clk);
			ap.write(trans);
	endtask
endclass
