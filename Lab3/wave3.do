vlib work
vlog -timescale 1ns/1ns lab3part3.v

# Load simulation using mux as the top level simulation module.
vsim lab3part3

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# +1, out = 00000101
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 0
force {KEY[0]} 0
force {KEY[1]} 0
force {KEY[2]} 0
run 10ns

# add, out = 00001110
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 1
force {KEY[0]} 0 0, 1 10
force {KEY[1]} 1 0, 0 10
force {KEY[2]} 0
run 20ns

# xoror, out = 01110101
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 1
force {SW[6]} 1
force {SW[7]} 0
force {KEY[0]} 1
force {KEY[1]} 1
force {KEY[2]} 0
run 10ns

# bitor, out = 00000000, 00000001
force {SW[0]} 0 0, 1 10
force {SW[1]} 0 0
force {SW[2]} 0 0
force {SW[3]} 0 0
force {SW[4]} 0 0
force {SW[5]} 0 0
force {SW[6]} 0 0
force {SW[7]} 0 0
force {KEY[0]} 0
force {KEY[1]} 0
force {KEY[2]} 1
run 20ns

#cat, out = 00110110
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 1
force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 0
force {KEY[0]} 1
force {KEY[1]} 0
force {KEY[2]} 1
run 10ns
