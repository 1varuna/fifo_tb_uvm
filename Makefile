# Commands for ModelSim/Questa
all:	compile start_sim add_wave run quit


compile:
	vlog -sv fifo.sv fifo_intf.sv fifo_top.sv	
#vlog -sv fifo.sv fifo_intf.sv fifo_env.sv test.sv fifo_top.sv

start_sim:
	vsim -voptargs=+acc work.fifo_top -novopt +test_name="write_only"	# test_name can be changed accordingly

add_wave:
	do waves.do


run:
	run -all

quit:
	quit -sim


