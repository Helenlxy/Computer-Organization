module lab5part3(SW, KEY, LEDR, CLOCK_50);
	input [2:0] SW;
	input CLOCK_50;
	input [1:0] KEY;
	output [0:0] LEDR;
	
	morse m0(SW[2:0], KEY[1], CLOCK_50, KEY[0], LEDR[0]);

endmodule

module morse(key, start, clk, asr_n, out);
	input [2:0] key;
	input start, asr_n, clk;
	output out;
	
	wire [15:0] letter;
	wire [24:0] rdval;
	wire shift_enable;
	
	lut lut0(key, letter);
	ratedivider rd0(1'd1, 25'd24999999, clk, asr_n, rdval);
	assign shift_enable = (rdval == 0) ? 1 : 0;	
	shiftregister s0(shift_enable, letter, start, asr_n, clk, out);
endmodule

module lut(key, out);
	input [2:0] key;
	output reg [15:0] out;
	
	always @(*)
	begin
		case(key)
			3'd0: out = 16'b1010100000000000;
			3'd1: out = 16'b1110000000000000;
			3'd2: out = 16'b1010111000000000;
			3'd3: out = 16'b1010101110000000;
			3'd4: out = 16'b1011101110000000;
			3'd5: out = 16'b1110101011100000;
			3'd6: out = 16'b1110101110111000;
			3'd7: out = 16'b1110111010100000;
		endcase
	end

endmodule

module shiftregister(enable, load, par_load, asr_n, clk, out);
	input enable, par_load, asr_n, clk;
	input [15:0] load;
	output reg out;
	
	reg [15:0] q;
	
	always @(posedge clk, negedge asr_n)
	begin
		if (asr_n == 0)
			begin
			out <= 0;
			q <= 16'b0;
			end
		else if (par_load == 1)
			begin
			out <= 0;
			q <= load;
			end
		else if (enable == 1)
			begin
			out <= q[15];
			q <= (q << 1'b1);
			end
	end

endmodule


module ratedivider(enable, load, clk, reset_n, q);
	input enable, clk, reset_n;
	input [24:0] load;
	output reg [24:0] q;
	
	always @(posedge clk, negedge reset_n)
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
