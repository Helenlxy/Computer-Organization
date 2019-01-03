vlib work
vlog -timescale 1ns/1ns lab3part2.v

# Load simulation using mux as the top level simulation module.
vsim lab3part2

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# a = 0000, b = 0000, cin = 0
# cout = 0, s = 0000
force {a[0]} 0
force {a[1]} 0
force {a[2]} 0
force {a[3]} 0
force {b[0]} 0
force {b[1]} 0
force {b[2]} 0
force {b[3]} 0
force {cin} 0
run 20ns

# a = 0100, b = 0001, cin = 0
# cout = 0, s = 0101
force {a[0]} 0
force {a[1]} 0
force {a[2]} 1
force {a[3]} 0
force {b[0]} 1
force {b[1]} 0
force {b[2]} 0
force {b[3]} 0
force {cin} 0
run 20ns

# a = 1111, b = 1111, ci = 0
# cout = 1, s = 1110
force {a[0]} 1
force {a[1]} 1
force {a[2]} 1
force {a[3]} 1
force {b[0]} 1
force {b[1]} 1
force {b[2]} 1
force {b[3]} 1
force {cin} 0
run 20ns

# a = 0001, b = 1111, ci = 0
# cout = 1, s = 0000
force {a[0]} 1
force {a[1]} 0
force {a[2]} 0
force {a[3]} 0
force {b[0]} 1
force {b[1]} 1
force {b[2]} 1
force {b[3]} 1
force {cin} 0
run 20ns

# a = 0101, b = 1010, ci = 0
# cout = 0, s = 1111
force {a[0]} 1
force {a[1]} 0
force {a[2]} 1
force {a[3]} 0
force {b[0]} 0
force {b[1]} 1
force {b[2]} 0
force {b[3]} 1
force {cin} 0
run 20ns
