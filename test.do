vlog *.sv
vsim -voptargs=+acc work.simtop 
add wave -position insertpoint sim:/simtop/my_cpu_dut/*
add wave -position insertpoint sim:/simtop/my_cpu_dut/cu/*
add wave -position insertpoint  \
sim:/simtop/my_cpu_dut/rf/mem
run 1000
