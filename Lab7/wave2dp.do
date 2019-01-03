vlib work

vlog -timescale 1ps/1ps lab7part2.v

vsim datapath

log {/*}
add wave {/*}

force {clk} 0 0, 1 1 -r 2

force {reset_n} 0 0, 1 4

force {ld_x} 0 0, 1 4, 0 8

force {ld_y} 0 0, 1 8, 0 12

force {pos} 0001000 0

force {color_in} 001 0

force {enable} 0 0, 1 12

run 45ps
