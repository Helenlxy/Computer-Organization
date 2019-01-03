vlib work
vlog -timescale 1ns/1ns sequence_detector.v
vsim sequence_detector

log {/*}
add wave {/*}
#SW[0] reset when 0
#SW[1] input signal
#KEY[0] clock signal
#LEDR[3:0] displays current state
#LEDR[9] displays output
# clock
force {KEY[0]} 0 0, 1 5 -repeat 10
# reset
force {SW[0]} 0 0, 1 10, 0 100, 1 105
# load pattern
force {SW[1]} 0 0, 1 40, 0 80, 1 90, 0 100, 1 140, 0 160, 1 170, 0 210

run 250ns
