/*
* File: fifo_tb_pkg.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Package containing all testbench files.
	* Called in test.sv file, included in the fifo_top.sv file 
*/

// NOTE: Package cannot include Interface file!!
package fifo_tb_pkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "defines.sv"		// Contains defines for FIFO DUT
	`include "fifo_seq_item.sv"
	`include "fifo_drv.sv"
	`include "fifo_slv_drv.sv"
	`include "fifo_input_mon.sv"
	`include "fifo_output_mon.sv"
	`include "fifo_agent.sv"
	`include "fifo_sb.sv"
	`include "fifo_env.sv"
	
	/*
	* Coverage and Assertions
	*/

	//`include "fifo_assertions.sv"
	//`include "fifo_coverage.sv"
	
	/*
	*	TODO Include test files here
	*/
	`include "fifo_base_seq.sv"
       	`include "fifo_test_uvm.sv"

endpackage
