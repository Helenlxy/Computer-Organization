vlib work

vlog -timescale 1ns/1ns lab4part2.v

vsim lab4part2

log {/*}
add wave {/*}

#clock
force {KEY[0]} 1 0, 0 5 -r 10

#reset
force {SW[9]} 1

# fix A values
force {SW[3: 0]} 0011 
#0, 0100 90, 0100 180 -r 270

#  functions, 10ns each:
force {SW[7: 5]} 000 00, 001 20, 010 30, 011 40, 100 50, 101 60, 110 70, 111 80 -r 90

run 100ns
