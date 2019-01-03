//Data(A) SW[3:0]

module lab4part2(LEDR, SW, KEY, HEX0, HEX4, HEX5);
	input [9:0] SW;
	input [0:0] KEY;
	output [7:0] LEDR;
	output [6:0] HEX0, HEX4, HEX5;
	wire [3:0] alu1;
	wire [3:0] alu2;
	wire cout1;
	wire cout2;
	wire [7:0] registerout;
	reg [7:0] Out;

	register r1(Out, KEY[0], SW[9], registerout);
	lab3part2 function1(SW[3:0], 4'b0001, 1'b0, alu1[3:0], cout1);
	lab3part2 function2(SW[3:0], registerout[3:0], 1'b0, alu2[3:0], cout2);

	always @(*)
    begin
        case (SW[7:5]) 
            3'b000: Out = {3'b000, cout1, alu1[3:0]};
            3'b001: Out = {3'b000, cout2, alu2[3:0]};
            3'b010: Out = SW[3:0] + registerout[3:0];
            3'b011: Out = {SW[3:0] | registerout[3:0], SW[3:0] ^ registerout[3:0]};
            3'b100: Out = {7'b0000000, SW[3] | SW[2] | SW[1] | SW[0] | registerout[3] | registerout[2] | registerout[1] | registerout[0]};
            3'b101: Out = registerout[3:0] << SW[3:0];
            3'b110: Out = registerout[3:0] >> SW[3:0];
            3'b111: Out = registerout[3:0] * SW[3:0];
            default : Out = 8'b00000000;
        endcase
    end

    assign LEDR = registerout;

    hex hex0(HEX0[6:0], SW[3:0]);
    hex hex4(HEX4[6:0], registerout[3:0]);
    hex hex5(HEX5[6:0], registerout[7:4]);
endmodule

module register(d, clk, reset_n, q);
	input [7:0] d;
	input clk, reset_n;
	output [7:0] q;
	reg [7:0] q;
	always @(posedge clk)
	begin
		if (reset_n == 1'b0)
			q <= 8'b00000000;
		else
			q <= d;
	end
endmodule

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
