vlib work

vlog -timescale 1ps/1ps lab7part2.v

vsim combined

log {/*}
add wave {/*}

force {clk} 0 0, 1 1 -r 2

force {reset_n} 0 0, 1 4

force {ld} 0 0, 1 8, 0 12

force {draw} 0 0, 1 16, 0 20

force {pos} 0001000 0

force {color_in} 001 0

run 60ps
