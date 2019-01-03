vlib work

vlog -timescale 1ns/1ns divider.v

vsim divider

log {/*}
add wave {/*}

force {clk} 0 0, 1 1 -r 2

force {resetn} 0 0, 1 2 -r 100

force {go} 0 0, 1 10, 0 20 -r 100

# divided = 0111, divisor = 0011, data_result = 000010010
#           1011,           0011,               000100011
force {data_in} 01110011 0, 10000011 100


run 200ns
