module lab3part2(a, b, cin, s, cout);
	input [3:0] a;
	input [3:0] b;
	input cin;
	output [3:0] s;
	output cout;

	wire connect1, connect2, connect3;

	fulladder fa1(a[0], b[0], cin, s[0], connect1);
	fulladder fa2(a[1], b[1], connect1, s[1], connect2);
	fulladder fa3(a[2], b[2], connect2, s[2], connect3);
	fulladder fa4(a[3], b[3], connect3, s[3], cout);
endmodule

module fulladder(x, y, z, u, v);
	input x, y, z;
	output u, v;

	assign u = (x ^ y ^ z) | (x & y & z);
	assign v = (x & y) | (z & (x ^ y));
endmodule
	
