vlib work

vlog -timescale 1ps/1ps ram32x4.v

vsim -L altera_mf_ver ram32x4

log {/*}
add wave {/*}

force {clock} 0 0, 1 2 -r 4

force {address} 00000 0, 00001 4 , 00010 8, 00011 12, 00100 16 -r 20

force {data} 1111 0, 1110 4, 1101 8, 1100 12, 1011 16, 1111 20, 1110 24, 1101 28, 1100 32, 1011 36, 0000 40

force {wren} 0 0, 1 22, 0 30, 1 38, 0 40


run 62ps
