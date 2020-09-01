/*
* File: fifo_sb.sv
* Author: Varun Anand
* Description: Fifo Scoreboard class which helps
* check data, sampled using input and output monitors. 
	*/

       class fifo_sb #(parameter FIFO_WIDTH=32, parameter FIFO_DEPTH=32) extends uvm_scoreboard; 

	       `uvm_component_utils(fifo_sb)

	       uvm_tlm_analysis_fifo #(fifo_seq_item) in_mon_fifo;
	       uvm_tlm_analysis_fifo #(fifo_seq_item) out_mon_fifo;

	       // Initialize counter variable to keep 
	       // track of transactions processed

	       integer trans_count;

		function new (string name,uvm_component parent);	// Class constructor
			super.new(name,parent);			// UVM Env - parent
		endfunction

		virtual function void build_phase(uvm_phase phase);	// *_phase() signature always accepts uvm_phase type as input
			super.build_phase(phase);
			in_mon_fifo = new ("in_mon_fifo",this);
			out_mon_fifo = new ("out_mon_fifo",this);
		endfunction

	       // Declare queues to save incoming
	       // data from monitors

	       logic [FIFO_WIDTH-1:0] in_stream_q[$];	// data_in queue
	       logic [FIFO_WIDTH-1:0] out_stream_q[$];	// data_out queue
	       logic [FIFO_WIDTH-1:0] temp_in_data;	// Temporary queue to hold input data
	       logic [FIFO_WIDTH-1:0] temp_out_data;	// Temporary queue to hold output data
	       /*
	       logic in_stream[$];	// Bit 0 - rd_en, 1 - wr_en, remaining: data_in
	       logic out_stream[$];	// Bit 0 - rd_en, 1 - empty, 2 - full, remaining : data_out
	       logic temp_in_data;	// Temporary queue to hold input data
	       logic temp_out_data;	// Temporary queue to hold output data
	       */
	      bit full_q[$];	// Queue to hold full signal values
	      bit empty_q[$];	// Queue to hold empty signal values
	      bit wr_en_q[$];
	      bit rd_en_in_q[$];
	      bit rd_en_out_q[$];

	      // Temporary output queues
	      bit temp_wr_en;
	      bit temp_rd_en_in;
	      bit temp_rd_en_out;
	      bit temp_full;
	      bit temp_empty;

	      // Declare SB events
	      event data_in_ev;			// To signal when an input write and data arrive
	      event data_out_ev;			// To signal when an output read and data arrive

	      task in_queue;
		      fifo_seq_item in_trans;		// Incoming trans from input monitor
		      in_trans = new();
		      //$display("\t SCOREBOARD:: Inside in_queue() \n");
		      forever begin
			      in_mon_fifo.get(in_trans);
			      $display("\tSCOREBOARD::in_queue() : Transaction info: wr_en = %0d, rd_en = %0d, data_in=%0d\n",in_trans.wr_en,in_trans.rd_en,in_trans.data_in);
			      begin
				      wr_en_q.push_back(in_trans.wr_en);
				      in_stream_q.push_back(in_trans.data_in);
				      ->data_in_ev;
				      rd_en_in_q.push_back(in_trans.rd_en);
			      end
		      end

	      endtask

	      task out_queue;
		      fifo_seq_item out_trans;	// Incoming trans from output monitor
		      out_trans = new();
		      $display("\t SCOREBOARD:: Inside out_queue() \n");
		      forever begin
			      out_mon_fifo.get(out_trans);
			      $display("\tSCOREBOARD::out_queue() : Transaction info: wr_en = %0d, rd_en = %0d, data_out=%0d, full : %0d, empty: %0d\n",out_trans.wr_en,out_trans.rd_en,out_trans.data_out,out_trans.full,out_trans.empty);
				      rd_en_out_q.push_back(out_trans.rd_en);	// forcing wr_en to 0
				      out_stream_q.push_back(out_trans.data_out);	// forcing wr_en to 0
				      ->data_out_ev;
				      full_q.push_back(out_trans.full);
				      empty_q.push_back(out_trans.empty);
		      end
	      endtask

	      task main_check;		// main task to compare input and output data
		      trans_count = 0;

		      forever begin
			      @(data_in_ev or data_out_ev);
		      begin
			      temp_wr_en = wr_en_q.pop_front();
			      temp_in_data = in_stream_q.pop_front();
			      temp_rd_en_in = rd_en_in_q.pop_front();
			      temp_rd_en_out = rd_en_out_q.pop_front();
			      temp_out_data = out_stream_q.pop_front();
			      temp_full = full_q.pop_front();
			      temp_empty = empty_q.pop_front();

			      if((temp_rd_en_in==1'b1)&&(temp_rd_en_out==1'b1))
			      begin
				      if(temp_in_data!=temp_out_data)
					      $error("\t SCOREBOARD::main_check() : Data Mismatch!\n");
				      else
					      trans_count++;		
			      end

			      if(trans_count==FIFO_DEPTH)
			      begin
				      if(temp_full==1'b1)
					      $display("\t SCOREBOARD::main_check() : FIFO FULL correctly received\n");
				      else
					      $error("\t SCOREBOARD::main_check() : FIFO FULL not received\n");
			      end
		      end
	      end
      endtask

      task run_phase(uvm_phase phase);
		super.run_phase(phase);
		      fork
			      in_queue;
			      out_queue;
			      main_check;
		      join_none
      endtask
endclass
