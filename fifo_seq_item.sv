/*
* File: fifo_seq_item.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: "Transaction class" containing randomizable data members
* and constraints.
*/
class fifo_seq_item #(parameter FIFO_WIDTH=32) extends uvm_sequence_item;

	//`uvm_object_utils(fifo_seq_item)
	`define S_DATA (2**((FIFO_WIDTH)/4))	// Defining range for small data values	
	`define M_DATA (2**((FIFO_WIDTH)/2))	// Defining range for medium data values	
	`define L_DATA (2**(FIFO_WIDTH))	// Defining range for large data values	

	rand bit [FIFO_WIDTH-1:0] data_in;
	rand bit wr_en, rd_en;
	logic [FIFO_WIDTH-1:0] data_out;	// To observe output at FIFO slave driver
	logic full,empty;	

	// Utility/Field Macros
	// Why ? 
	// Can use it with std in-built functions
	// like copy, clone etc.

	
	`uvm_object_utils_begin(fifo_seq_item)
		`uvm_field_int(data_in,	UVM_ALL_ON)	
		`uvm_field_int(wr_en,	UVM_ALL_ON)	
		`uvm_field_int(rd_en,	UVM_ALL_ON)	
		`uvm_field_int(data_out,UVM_ALL_ON)	
		`uvm_field_int(full,	UVM_ALL_ON)	
		`uvm_field_int(empty,	UVM_ALL_ON)	
	`uvm_object_utils_end
	
	function new(string name = "fifo_seq_item");
		super.new(name);
	endfunction
	
	constraint wr_rd {
		wr_en!=rd_en;		// Mutex condition for read write
	}

/*	
	constraint wr_en_c {
	wr_en dist {1:=80,0:=20};	// constraint on write enable
	}	

	constraint rd_en_c {
	rd_en dist {1:=20,0:=80};	// constraint on write enable
	}
*/	

	// TODO Check why data_in constraint does not work
	

	/*	
	constraint data_in_c{		// constraint on data generation
		//data_in inside {[`M_DATA:`L_DATA-1]};
		data_in dist
		{
			[1000:`S_DATA-1] :=40,
			[`S_DATA:`M_DATA-1] :=40,
			[`M_DATA:`L_DATA] :=20
		};
		
		/*
		data_in dist {
	[0:(2<<FIFO_WIDTH)/2] := 50,
	[((2<<FIFO_WIDTH)/2):(2<<FIFO_WIDTH-1)] := 50
		};
		*/
	//}

endclass
