vlib work

vlog -timescale 1ns/1ns lab5part2.v

vsim counter

log {/*}
add wave {/*}

# test case:
# 2'b01: max = 28'd1;
# 2'b10: max = 28'd3;
# 2'b11: max = 28'd7;
force {frequency[0]} 0 0, 1 50 -r 100
force {frequency[1]} 0 0, 1 100
force {enable} 1
force {par_load} 0 0, 1 20, 0 25
force {load[3:0]} 1110 
force {reset_n} 0 0, 1 8
force {clk} 0 0, 1 2 -r 4
run 400ns
