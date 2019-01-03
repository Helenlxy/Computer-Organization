module lab4part3(SW, LEDR, KEY);
	input [9:0] SW;
	input [3:0] KEY;
	output [7:0] LEDR;
	wire [8:0] wire1;

	mux2to1 u0(1'b0, wire1[7], KEY[3], wire1[8]);

	shifterbit u1(
		.in(wire1[8]),
		.load_val(SW[7]),
		.shift(KEY[2]),
		.load_n(KEY[1]),
		.clk(KEY[0]),
		.reset_n(SW[9]),
		.out(wire1[7])
	);

	shifterbit u2(
		.in(wire1[7]),
		.load_val(SW[6]),
		.shift(KEY[2]),
		.load_n(KEY[1]),
		.clk(KEY[0]),
		.reset_n(SW[9]),
		.out(wire1[6])
	);

	shifterbit u3(
		.in(wire1[6]),
		.load_val(SW[5]),
		.shift(KEY[2]),
		.load_n(KEY[1]),
		.clk(KEY[0]),
		.reset_n(SW[9]),
		.out(wire1[5])
	);

	shifterbit u4(
		.in(wire1[5]),
		.load_val(SW[4]),
		.shift(KEY[2]),
		.load_n(KEY[1]),
		.clk(KEY[0]),
		.reset_n(SW[9]),
		.out(wire1[4])
	);

	shifterbit u5(
		.in(wire1[4]),
		.load_val(SW[3]),
		.shift(KEY[2]),
		.load_n(KEY[1]),
		.clk(KEY[0]),
		.reset_n(SW[9]),
		.out(wire1[3])
	);

	shifterbit u6(
		.in(wire1[3]),
		.load_val(SW[2]),
		.shift(KEY[2]),
		.load_n(KEY[1]),
		.clk(KEY[0]),
		.reset_n(SW[9]),
		.out(wire1[2])
	);

	shifterbit u7(
		.in(wire1[2]),
		.load_val(SW[1]),
		.shift(KEY[2]),
		.load_n(KEY[1]),
		.clk(KEY[0]),
		.reset_n(SW[9]),
		.out(wire1[1])
	);

	shifterbit u8(
		.in(wire1[1]),
		.load_val(SW[0]),
		.shift(KEY[2]),
		.load_n(KEY[1]),
		.clk(KEY[0]),
		.reset_n(SW[9]),
		.out(wire1[0])
	);

	assign LEDR[7:0] = wire1[7:0];
endmodule


module shifterbit(in, load_val, shift, load_n, clk, reset_n, out);
	input in, load_val, shift, load_n, clk, reset_n;
	output out;
	wire wire1, wire2;
	
	flipflop u0(
		.d(wire2),
		.clk(clk),
		.reset_n(reset_n),
		.q(out)
	);
	
	mux2to1 u1(
		.x(out),
		.y(in),
		.s(shift),
		.m(wire1)
	);
	
	mux2to1 u2(
		.x(load_val),
		.y(wire1),
		.s(load_n),
		.m(wire2)
	);
endmodule

module flipflop(d, clk, reset_n, q);
	input d;
	input clk, reset_n;
	output q;
	reg q;
	always @(posedge clk)
	begin
		if (reset_n == 1'b0)
			q <= 0;
		else
			q <= d;
	end
endmodule

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;

endmodule
