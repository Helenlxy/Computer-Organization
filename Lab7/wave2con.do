vlib work

vlog -timescale 1ps/1ps lab7part2.v

vsim control

log {/*}
add wave {/*}

force {clk} 0 0, 1 1 -r 2

force {reset_n} 0 0, 1 4

force {ld} 0 0, 1 8, 0 12, 1 40, 0 44

force {draw} 0 0, 1 16, 0 20


run 60ps
