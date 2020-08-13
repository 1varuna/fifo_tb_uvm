`include "defines.sv"
`include "test.sv"
`include "fifo_assertions.sv"

// Defining input data range based on the width of chosen data
`define MAX_VAL (2**`DEF_FIFO_WIDTH)		// Maximum value
`define QUART_VAL (2**(`DEF_FIFO_WIDTH/4))	// Quarter of max value
`define HALF_VAL (2**(`DEF_FIFO_WIDTH/2))	// Half of max value

// Define range for small, medium and large number of input packets
`define S_PKT `DEF_FIFO_DEPTH/4
`define M_PKT `DEF_FIFO_DEPTH/2
`define L_PKT `DEF_FIFO_DEPTH

module fifo_coverage();
	logic wr_en, rd_en;
	logic [`DEF_FIFO_WIDTH-1:0] data_in;
	logic full, empty;
	logic clk,rstN;

	// Defining covergroups
	
	/*
	* Adding coverage to check if generated data covers data 
	* input values from the lowest to the highest 
	* for a given vector width
	*/

	covergroup c_data_range @(posedge clk);		
		range: coverpoint data_in {
			bins low = {0,`QUART_VAL-1};
			bins med = {`QUART_VAL,`HALF_VAL-1};
			bins high = {`HALF_VAL,`MAX_VAL};
			}
	endgroup

	/*
	* Adding Covergroup to cover number of packets 
	* being generated during randomization
	*/
	covergroup c_num_data @(posedge clk);
		coverpoint test.num_data {
			bins low = {0,`S_PKT-1};
			bins med = {`S_PKT,`M_PKT-1};
			bins high = {`M_PKT,`L_PKT-1};
		}
	endgroup
	
	/*
	* ADD coverage on assertions
	*/
       
       /*	TODO COMPLETE
       covergroup c_assertions @(posedge clk);
	       coverpoint a_reset;		// Reset
	       coverpoint a_wr_rd_enable;	// Mutex assertion
	       coverpoint a_inv_rd_empty;	// Invalid read when empty
	       coverpoint a_inv_wr_fill;	// Invalid write when full
       endgroup
	*/
endmodule
