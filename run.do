# Compile
vlog -sv fifo.sv fifo_intf.sv fifo_top.sv
# Start Sim
vsim -voptargs=+acc work.fifo_top -novopt +UVM_TESTNAME=fifo_test_uvm
# Add waves
do waves.do
# Run Sim
run -all
