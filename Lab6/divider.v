//Sw[7:0] data_in

//KEY[0] synchronous reset when pressed
//KEY[1] go signal

//LEDR displays result
//HEX0 & HEX1 also displays result

module fpga_top(SW, KEY, CLOCK_50, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input [9:0] SW;
    input [3:0] KEY;
    input CLOCK_50;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    wire resetn;
    wire go;

    wire [8:0] data_result;
    assign go = ~KEY[1];
    assign resetn = KEY[0];

    divider u0(
        .clk(CLOCK_50),
        .resetn(resetn),
        .go(go),
        .data_in(SW[7:0]),
        .data_result(data_result)
    );
      
    assign LEDR[9:0] = {6'd0, data_result[3:0]};

    hex_decoder H0(
        .hex_digit(SW[3:0]), 
        .segments(HEX0)
        );
        
    hex_decoder H1(
        .hex_digit(SW[7:4]), 
        .segments(HEX1)
        );

    hex_decoder H4(
        .hex_digit(data_result[3:0]), 
        .segments(HEX4)
        );

    hex_decoder H5(
        .hex_digit(data_result[7:4]), 
        .segments(HEX5)
        );

    hex_decoder H2(
        .hex_digit(4'd0), 
        .segments(HEX2)
        );

    hex_decoder H3(
        .hex_digit(4'd0), 
        .segments(HEX3)
        );

endmodule

module divider(
    input clk,
    input resetn,
    input go,
    input [7:0] data_in,
    output [8:0] data_result
    );

    // lots of wires to connect our datapath and control
    wire ld_a, ld_m, ld_q;
    wire ld_alu_out;
    wire alu_select_a;
    wire [1:0] alu_op;

    control C0(
        .clk(clk),
        .resetn(resetn),
        
        .go(go),
        
        .ld_alu_out(ld_alu_out), 
        .ld_a(ld_a),
        .ld_m(ld_m),
        .ld_q(ld_q), 
        .ld_r(ld_r), 
        
        .alu_select_a(alu_select_a),
        .alu_op(alu_op)
    );

    datapath D0(
        .clk(clk),
        .resetn(resetn),

        .ld_alu_out(ld_alu_out), 
        .ld_a(ld_a),
        .ld_m(ld_m),
        .ld_q(ld_q), 
        .ld_r(ld_r), 

        .alu_select_a(alu_select_a),
        .alu_op(alu_op),

        .data_in(data_in),
        .data_result(data_result)
    );
                
 endmodule        
                

module control(
    input clk,
    input resetn,
    input go,

    output reg  ld_a, ld_m, ld_q, ld_r,
    output reg  ld_alu_out,
    output reg  alu_select_a,
    output reg [1:0] alu_op
    );

    reg [3:0] current_state, next_state; 
    reg [1:0] count;
  
    localparam  S_LOAD_INPUT        = 4'd0,
                S_LOAD_INPUT_WAIT   = 4'd1,
                SHIFT_LEFT          = 4'd2,
                SUBTRACT_DIVISOR    = 4'd3,
                ADD_DIVISOR         = 4'd4,
                SET_Q0              = 4'd5,
                OUTPUT              = 4'd6;
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                S_LOAD_INPUT: begin
			next_state = go ? S_LOAD_INPUT_WAIT : S_LOAD_INPUT; // Loop in current state until value is input
			count = 2'd0;
		end
                S_LOAD_INPUT_WAIT: next_state = go ? S_LOAD_INPUT_WAIT : SHIFT_LEFT; // Loop in current state until go signal goes low
                SHIFT_LEFT: next_state = SUBTRACT_DIVISOR;
                SUBTRACT_DIVISOR: next_state = ADD_DIVISOR;
                ADD_DIVISOR: next_state = SET_Q0;
                SET_Q0: begin
                    next_state = (count == 2'b11) ? OUTPUT : SHIFT_LEFT; 
                    count = count + 1;
                end
                OUTPUT: next_state = S_LOAD_INPUT;
            default:     next_state = S_LOAD_INPUT;// we will be done our five operations, start over after
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        ld_alu_out = 1'b0;
        ld_a = 1'b0;
        ld_m = 1'b0;
        ld_q = 1'b0;
        ld_r = 1'b0;
        alu_select_a = 1'b0;
        alu_op       = 2'b00;

        case (current_state)
            S_LOAD_INPUT: begin
                ld_m = 1'b1;
                ld_q = 1'b1;
                end
            SHIFT_LEFT: begin 
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_q = 1'b1;
                alu_select_a = 1'b1; 
                alu_op = 2'b00; 
            end
            SUBTRACT_DIVISOR: begin 
                ld_alu_out = 1'b1; ld_a = 1'b1; 
                alu_select_a = 1'b0; 
                alu_op = 2'b01; 
            end
            ADD_DIVISOR: begin 
                ld_alu_out = 1'b1; ld_a = 1'b1; 
                alu_select_a = 1'b0; 
                alu_op = 2'b10; 
            end
            SET_Q0: begin 
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_q = 1'b1;
                alu_select_a = 1'b0; 
                alu_op = 2'b11; 
            end
            OUTPUT: begin 
                ld_r = 1'b1; // store result in result register
            end
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_INPUT;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module datapath(
    input clk,
    input resetn,
    input [7:0] data_in,
    input ld_alu_out, 
    input ld_m, ld_a, ld_q,  
    input ld_r,
    input [1:0] alu_op, 
    input alu_select_a, 
    output reg [8:0] data_result
    );
    
    // input registers
    reg [4:0] divisor, Register_A, Register_B;
    reg [3:0] dividend;

    // output of the alu
    reg [8:0] alu_out;
    // alu input muxes
    reg [4:0] alu_a;

    reg ld_b;
    
    // Registers a, b, c, x with respective input logic
    always @ (posedge clk) begin
        if (!resetn) begin
            divisor <= 5'd0; 
            Register_A <= 5'd0; 
            dividend <= 4'd0; 
	    Register_B <= 5'd0;
        end
        else begin
            if (ld_m)
                divisor <= {1'b0, data_in[3:0]}; 
            if (ld_q)
                dividend <= ld_alu_out ? alu_out[3:0] : data_in[7:4]; 
            if (ld_a)
                Register_A <= alu_out[8:4];
	    if (ld_b)
		Register_B <= Register_A;
		ld_b <= 1'd0;
        end
    end
 
    // Output result register
    always @ (posedge clk) begin
        if (!resetn) begin
            data_result <= 9'd0; 
        end
        else 
            if(ld_r)
                data_result <= {Register_A, dividend};
    end

    // The ALU input multiplexers
    always @(*)
    begin
        case (alu_select_a)
            1'd0:
                alu_a = divisor;
            1'd1:
                alu_a = dividend;
            default: alu_a = 5'd0;
        endcase
    end

    // The ALU 
    always @(*)
    begin : ALU
        // alu
        case (alu_op)
            2'b00: begin
                   alu_out <= {Register_A, alu_a[3:0]} << 1'b1;// Perform left shift
                end
            2'b01: begin
                   alu_out[8:4] <= Register_A - alu_a; //subtract divisor from Register_A
		   ld_b <= 1'd1; 
                end
            2'b10: begin
                    if (Register_A[4]) begin
                        alu_out[8:4] <= Register_A + alu_a;
                        end
                    else alu_out[8:4] <= Register_A;
                end
            2'b11: begin
                    alu_out[0] <= ~Register_B[4];
                end
            default: alu_out <= {Register_A, alu_a};
        endcase
    end
    
endmodule


module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule
