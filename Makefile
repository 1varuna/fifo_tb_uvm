# Commands for ModelSim/Questa
all:	compile start_sim add_wave run quit


compile:
	vlog -sv fifo.sv fifo_intf.sv fifo_top.sv	

start_sim:
	vsim -voptargs=+acc work.fifo_top -novopt +UVM_TESTNAME=fifo_test_uvm

add_wave:
	do waves.do


run:
	run -all

quit:
	quit -sim


