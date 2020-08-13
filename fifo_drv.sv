/*
* File: fifo_drv.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Fifo Master Driver class which helps
* send a write request and input data into DUT. 
*/

class fifo_drv extends uvm_driver;

	`uvm_component_utils(fifo_drv)

	virtual interface fifo_intf fifo_vif;
	
	`define DRV_IF fifo_vif.fifo_drv_cb

	function new (string name,uvm_component parent);	// Class constructor
		super.new(name,parent);			// UVM Driver - parent
	endfunction

	virtual function void build_phase(uvm_phase phase);	// *_phase() signature always accepts uvm_phase type as input
		super.build_phase(phase);
		if(!uvm_config_db #(virtual fifo_intf) :: get(this,"","fifo_intf",fifo_vif)) begin
			`uvm_fatal(get_type_name(),"Didn't get handle to Virtual IF fifo_vif")
		end
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			fifo_seq_item trans;
			`uvm_info(get_type_name(),$sformatf("Waiting for data from sequencer"),UVM_LOW)
			seq_item_port.get_next_item(trans);
			drive_item(trans);
			seq_item_port.item_done();
		end
	endtask 


	task drive_item(fifo_seq_item trans);		// This task (user-defined) puts generated pkts from gen to drv

			`DRV_IF.wr_en<=0;

			@(posedge fifo_vif.clk);
			if(trans.wr_en)
			begin
			//$display("\tMASTER DRIVER::run() Transaction info INTO DUT: %0t ns wr_en = %0d, rd_en = %0d, data_in = %0d\n",$time,trans.wr_en,trans.rd_en,trans.data_in);
				`DRV_IF.wr_en <= trans.wr_en;
				`DRV_IF.data_in <= trans.data_in;

				@(posedge fifo_vif.clk);
				`DRV_IF.wr_en<=0;
			end

	endtask

endclass	
