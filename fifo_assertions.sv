
// Defining assertions for FIFO DUT

module fifo_assertions #(parameter FIFO_WIDTH=32) (
	input wire clk,
	input wire rstN,
	input wire wr_en,
	input wire rd_en,
	input wire [FIFO_WIDTH-1:0] data_in,
	input reg [FIFO_WIDTH-1:0] data_out,
	input wire empty,
	input wire full,
	input integer write_ptr,
	input integer read_ptr
	);
	
	// |-> Check immediately : Overlapping implication
	// |=> Check after 1 clock cycle : Non-Overlapping implication
	
	// Reset condition
	a_reset:	assert property (@(posedge clk) !rstN |-> (data_out=='h0));
	
	// Mutual exclusion condition for wr and rd enable
	a_wr_rd_enable:	assert property (@(posedge clk) disable iff (!rstN) !(wr_en&&rd_en));

	/*	TODO : COMPLETE LATER
	* More assertions to be added:
		* Valid upper count range i.e, number of transactions are less than
		* FIFO_DEPTH
		* Valid lower bound i.e, number of trans > 0
		* Invalid read after empty - ADDED 
		* Invalid write after full - ADDED
		*
	*/
       a_invalid_rd_empty:	assert property (@(posedge clk) disable iff (!rstN) empty |-> read_ptr==$past(read_ptr));
       
       a_invalid_wr_full:	assert property (@(posedge clk) disable iff (!rstN) full |-> write_ptr==$past(write_ptr));

       a_empty_ptr:		assert property (@(posedge clk) disable iff (!rstN) empty |-> (write_ptr==0&&read_ptr==0))
       				else $error("\t FIFO_ASSERTIONS:: Read and Write address not pointing to start address, when FIFO is empty");
endmodule
