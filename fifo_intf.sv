/*
* File: fifo_intf.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Fifo Interface used to group signals at pin level
* specific to classes they interface with, and define their directions
* using modports.
*/

interface fifo_intf #(parameter FIFO_WIDTH=32, parameter FIFO_DEPTH=(2**5))(
	input logic clk,				// input clock
	input logic rstN,				//active low reset
	input logic wr_en,				// write enable
	input logic [FIFO_WIDTH-1:0] data_in,		// Input Data
	input logic rd_en,				// read enable
	output logic empty,				// fifo empty
	output logic full,				// fifo full
	output logic [FIFO_WIDTH-1:0] data_out	// Output data
	);

	default clocking fifo_mon_cb @(posedge clk);	// Monitor clocking Block : Default	
	default input #2ns output #2ns;			// Defining default input and output clock skews
	
	//input clk;				// input clock
	//input rstN;				//active low reset
	input wr_en;				// write enable
	input data_in;				// Input Data
	input rd_en;				// read enable
	input empty;				// fifo empty
	input full;				// fifo full
	input data_out;				// Output data

	endclocking
	
	modport fifo_mon_mp(clocking fifo_mon_cb,input clk,input rstN);	// Defining port directions for fifo monitor

	clocking fifo_drv_cb @(posedge clk);
		default input #2ns output #2ns;
		//input clk;
		//input rstN;
		output data_in;
		output wr_en;
	endclocking

	modport fifo_drv_mp(clocking fifo_drv_cb,input clk,input rstN);	// Defining port directions for fifo driver

	clocking fifo_slv_drv_cb @(posedge clk);
		default input #2ns output #2ns;
		//input clk;
		//input rstN;
		input data_out;
		input full;
		input empty;
		output rd_en; 
		
	endclocking

	modport fifo_slv_drv_mp(clocking fifo_slv_drv_cb,input clk,input rstN);	// Defining port directions for fifo slv

endinterface
