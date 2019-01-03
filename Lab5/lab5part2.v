module lab5part2(SW, HEX0, CLOCK_50);
	input [9:0]SW;
	input CLOCK_50;
	output [6:0]HEX0;
	wire [3:0]wire1;

	counter c2(SW[2], SW[5:3], SW[6], CLOCK_50, SW[7], SW[1:0], wire1);

	hex hex0(HEX0[6:0], wire1);
endmodule


module counter(enable, load, par_load, clk, reset_n, frequency, out);
	input clk, enable, par_load, reset_n;
	input [1:0] frequency;
	input [3:0] load;
	output [3:0] out;
	wire [27:0] wire1;

	reg [27:0]max;
	reg cenable;
	
	always @(posedge clk)
		begin
			cenable = (wire1 == 0) ? 1:0;
			case(frequency)
				2'b00: max = 0;
				2'b01: max = 28'd49999999;
				2'b10: max = 28'd99999999;
				2'b11: max = 28'd199999999;
			endcase
		end

	ratedivider r1hz(enable, max, clk, reset_n, wire1);
		
	displaycounter d(cenable, load, par_load, clk, reset_n, out);

endmodule

module displaycounter(enable, load, par_load, clk, reset_n, q);
	input enable, clk, par_load, reset_n;
	input [3:0] load;
	output reg [3:0] q;
	
	always @(posedge clk)
	begin
		if (reset_n == 1'b0)
			q <= 4'b0000;
		else if (par_load == 1'b1)
			q <= load;
		else if (enable == 1'b1)
			begin
				q <= q + 1'b1;
			end
	end
endmodule

module ratedivider(enable, load, clk, reset_n, q);
	input enable, clk, reset_n;
	input [27:0] load;
	output reg [27:0] q;
	
	always @(posedge clk)
	begin
		if (reset_n == 1'b0)
			q <= load;
		else if (enable == 1'b1)
			begin
				if (q == 0)
					q <= load;
				else
					q <= q - 1'b1;
			end
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
