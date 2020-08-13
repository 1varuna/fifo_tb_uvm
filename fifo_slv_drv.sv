/*
* File: fifo_slv_drv.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Fifo Slave Driver class which helps
* send a read request to read data from FIFO. 
*/

`ifndef FIFO_SLAVE
`define FIFO_SLAVE

class fifo_slv_drv extends uvm_driver #(fifo_seq_item);
	
	`uvm_component_utils(fifo_slv_drv)	

	virtual interface fifo_intf fifo_vif;
	`define SLAVE_IF fifo_vif.fifo_slv_drv_cb

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

	task drive_item(fifo_seq_item trans);
			
			`SLAVE_IF.rd_en<=0;

			@(posedge fifo_vif.clk);
			if(trans.rd_en) begin
				if(`SLAVE_IF.empty==1)
				begin
					$warning("\tfifo_slv_drv::run() %0t Attempting read on an empty fifo! \n",$time);
				end
				else begin
					$display("\tSLAVE DRIVER::run() Transaction info INTO DUT: %0t ns rd_en = %0d \n",$time,trans.rd_en);
					`SLAVE_IF.rd_en <= trans.rd_en;
					@(posedge fifo_vif.clk);
					`SLAVE_IF.rd_en <= 0;
					
				end
			end
	endtask

endclass
`endif
