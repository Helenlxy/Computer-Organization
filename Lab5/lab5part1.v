module lab5part1(SW, KEY, HEX0, HEX1);
	input [1:0]SW;
	input [0:0]KEY;
	output [6:0]HEX0, HEX1;
	wire [7:0]wire2;

	counter c1(
	.Enable(SW[1]),
	.clock(KEY[0]),
	.clear_b(SW[0]),
	.Q(wire2)
	);

	hex h0(HEX0[6:0], wire2[7:4]);
    hex h1(HEX1[6:0], wire2[3:0]);
endmodule



module counter(Enable, clock, clear_b, Q);
	input Enable, clock, clear_b;
	output [7:0]Q;
	wire [6:0]wire1;

	assign wire1[6] = Q[7] & Enable;
	assign wire1[5] = Q[6] & wire1[6];
	assign wire1[4] = Q[5] & wire1[5];
	assign wire1[3] = Q[4] & wire1[4];
	assign wire1[2] = Q[3] & wire1[3];
	assign wire1[1] = Q[2] & wire1[2];
	assign wire1[0] = Q[1] & wire1[1];

	mytff m1(
	.T(Enable),
	.clear_b(clear_b),
	.clk(clock),
	.Q(Q[7])
	);

	mytff m2(
	.T(wire1[6]),
	.clear_b(clear_b),
	.clk(clock),
	.Q(Q[6])
	);

	mytff m3(
	.T(wire1[5]),
	.clear_b(clear_b),
	.clk(clock),
	.Q(Q[5])
	);

	mytff m4(
	.T(wire1[4]),
	.clear_b(clear_b),
	.clk(clock),
	.Q(Q[4])
	);

	mytff m5(
	.T(wire1[3]),
	.clear_b(clear_b),
	.clk(clock),
	.Q(Q[3])
	);

	mytff m6(
	.T(wire1[2]),
	.clear_b(clear_b),
	.clk(clock),
	.Q(Q[2])
	);

	mytff m7(
	.T(wire1[1]),
	.clear_b(clear_b),
	.clk(clock),
	.Q(Q[1])
	);

	mytff m8(
	.T(wire1[0]),
	.clear_b(clear_b),
	.clk(clock),
	.Q(Q[0])
	);
endmodule


module mytff(T, clk, clear_b, Q);
	input T, clk, clear_b;
	output Q;
	reg Q;

	always @(posedge clk, negedge clear_b)
	begin
		if(clear_b == 1'b0)
			Q <= 1'b0;
		else
			Q <= ~Q&T|Q&~T;
	end
endmodule

module hex(HEX0, SW);
    input [3:0] SW;
    output [6:0] HEX0;

    assign HEX0[0] = (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (~SW[3] & SW[2] & ~SW[1] & SW[0]) | (SW[3] & SW[2] & ~SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & SW[0]);

    assign HEX0[1] = (~SW[3] & SW[2] & ~SW[1] & SW[0]) | (SW[2] & SW[1] & ~SW[0]) | (SW[3] & SW[2] & ~SW[0]) | (SW[3] & SW[1] & SW[0]);

    assign HEX0[2] = (~SW[3] & ~SW[2] & SW[1] & ~SW[0]) | (SW[3] & SW[2] & SW[1]) | (SW[3] & SW[2] & ~SW[0]) ;

    assign HEX0[3] = (~SW[3] & ~SW[2] & ~SW[1] & SW[0]) | (~SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (SW[2] & SW[1] & SW[0]) | (SW[3] & ~SW[2] & SW[1] & ~SW[0]);

    assign HEX0[4] = (~SW[3] & SW[0]) | (~SW[2] & ~SW[1] & SW[0]) | (~SW[3] & SW[2] & ~SW[1]);

    assign HEX0[5] = (~SW[3] & ~SW[2] & SW[0]) | (~SW[3] & ~SW[2] & SW[1]) | (~SW[3] & SW[1] & SW[0]) | (SW[3] & SW[2] & ~SW[1] & SW[0]);

    assign HEX0[6] = (~SW[3] & ~SW[2] & ~SW[1]) | (SW[3] & SW[2] & ~SW[1] & ~SW[0]) | (~SW[3] & SW[2] & SW[1] & SW[0]);

endmodule
