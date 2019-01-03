vlib work
vlog -timescale 1ns/1ns poly_function.v
vsim part2

log {/*}
add wave {/*}
#Sw[7:0] data_in
#KEY[0] synchronous reset when pressed
#KEY[1] go signal
#LEDR displays result
#HEX0 & HEX1 also displays result
force {clk} 0 0, 1 1 -r 2

force {resetn} 0 0, 1 2

force {go} 0 0, 1 10, 0 20 -r 30

#A = 9, B = 7, C = 5, X = 3
#result should be 107 which is 01101011 in binary
force {data_in} 00001001 0, 00000111 30, 00000101 60, 00000011 90


run 200ns
