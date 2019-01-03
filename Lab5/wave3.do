vlib work

vlog -timescale 1ns/1ns lab5part3.v

vsim morse

log {/*}
add wave {/*}

# reset
force {asr_n} 0 0, 1 5, 0 287, 1 292

force {key[2:0]} 011 0, 111 200

# clk
force {clk} 0 0, 1 1 -r 2

force {start} 1 0, 0 10, 1 200, 0 210
#, 1 20, 0 200, 1 204

run 400ns
