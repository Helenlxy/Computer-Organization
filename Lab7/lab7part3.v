module part3
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock      
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [7:0] y;
	wire writeEn;
	wire enable,ld_c;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		
		
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
    // Instansiate datapath
	// datapath d0(...);
      datapath d0(enable,CLOCK_50,ld_c,SW[9:7],KEY[0],x,y,colour);

    // Instansiate FSM control
    // control c0(...);
	   control c0(CLOCK_50,KEY[0],~KEY[1],enable,ld_c,writeEn);

    
endmodule

module delay_counter(clock,reset_n,enable,q);
		input clock;
		input reset_n;
		input enable;
		output reg [19:0] q;
		
		always @(posedge clock)
		begin
			if(reset_n == 1'b0)
				q <= 20'b11001110111001100001;
			else if(enable ==1'b1)
			begin
			   if ( q == 20'd0 )
					q <= 20'b11001110111001100001;
				else
					q <= q - 1'b1;
			end
		end
endmodule


module frame_counter(clock,reset_n,enable,q);
	input clock,reset_n,enable;
	output reg [3:0] q;
	
	always @(posedge clock)
	begin
		if(reset_n == 1'b0)
			q <= 4'b0000;
		else if(enable == 1'b1)
		begin
		  if(q == 4'b1111)
			  q <= 4'b0000;
		  else
			  q <= q + 1'b1;
		end
   end
endmodule

module x_counter(clock,clock_1,reset_n,enable,signal,q);
	input clock,enable,reset_n,signal,clock_1;
	output reg[7:0] q;

	always@(posedge clock)
	begin
		if(reset_n == 1'b0)
			q <= 8'b00000000;
	end
	always@(negedge clock_1)
	   if(reset_n == 1'b1)
			begin
			if(signal == 1'b1)
				q <= q + 1'b1;
			else
				q <= q - 1'b1;
		end
endmodule

module y_counter(clock,clock_1,reset_n,enable,signal,q);
	input clock,enable,signal,reset_n,clock_1;
	output reg[7:0] q;

   always@(posedge clock)
	begin
		if(reset_n == 1'b0)
			q <= 8'b00111100;
	end
	always@(negedge clock_1)
	   if(reset_n == 1'b1)
			begin
			if(signal == 1'b1)
				q <= q + 1'b1;
			else
				q <= q - 1'b1;
		end
endmodule


module v_register(clock,reset_n,y,direction);
	input clock,reset_n;
	input [7:0] y;
	output reg direction;
	
	always@(posedge clock)
	begin
		if(reset_n == 1'b0)
			direction <= 1'b1;
		else
		begin
			if(direction == 1'b1)
			begin
				if(y + 1 > 8'b01110111)
					direction <= 1'b0;
				else
					direction <= 1'b1;
			   end
			else
			begin
				if(y == 8'b00000000)
					direction <= 1'b1;
				else
					direction <= 1'b0;
			end
		end
		end
endmodule

module h_register(clock,reset_n,x,direction);
	input clock,reset_n;
	input [7:0] x;
	output reg direction;
	
	always@(posedge clock)
	begin
		if(reset_n == 1'b0)
			direction <= 1'b1;
		else
		begin
			if(direction == 1'b1)
			begin
				if(x + 1 > 8'b10011111)
					direction <= 1'b0;
				else
					direction <= 1'b1;
			   end
			else
			begin
				if(x == 8'b00000000)
					direction <= 1'b1;
				else
					direction <= 1'b0;
			end
		end
	end
endmodule


module datapath_helper
    (
        input clk,
        input reset_n,
        input [7:0] x_in,
        input [7:0] y_in,        
        input [2:0] color_in,
        input ld_c,
        input enable,
        output [7:0] x_out,
        output [7:0] y_out,
        output reg [2:0] color_out
    );
    
    reg [3:0] count;
    reg [7:0] x;
    reg [7:0] y; 
    
    // register
    always @(posedge clk) begin
        if (!reset_n) begin
            x <= 8'b0;
            y <= 8'b0;
            color_out <= 3'b0;
        end
        else begin
            x <= x_in;
            y <= y_in;
            if(ld_c == 1)
                color_out <= color_in;
        end
        
    end
    
    // counter
    always @(posedge clk) begin
        if (!reset_n)
            count <= 4'b0000;
        else if (enable) begin
            count <= count + 1'b1;
        end
    end
        
    assign x_out = x + count[1:0];
    assign y_out = y + count[3:2];
    
endmodule

module datapath(enable,clock,ld_c,colour,reset_n,X,Y,colour_out);
	input enable,clock,reset_n,ld_c;
	input [2:0] colour;
	output[7:0] X,Y;
	output[2:0] colour_out;
	
	wire[19:0] c0;
	wire[3:0] c1;
	wire signal_x,signal_y;
	wire[7:0] x_in,y_in;
	wire[2:0] colour_1;
	
	delay_counter m1(clock,reset_n,enable,c0);
	assign enable_1 = (c0 ==  20'd0) ? 1 : 0;
	frame_counter m2(clock,reset_n,enable_1,c1);
	assign enable_2 = (c1 == 4'b1111) ? 1 : 0;
	x_counter m3(clock,enable_2,reset_n,enable_2,signal_x,x_in);
	y_counter m4(clock,enable_2,reset_n,enable_2,signal_y,y_in);
	v_register m5(clock,reset_n,y_in,signal_y);
	h_register m6(clock,reset_n,x_in,signal_x);
	assign colour_1 = (c1 == 4'b1111) ? 3'b000 : colour;
	datapath_helper m7(clock,reset_n,x_in,y_in,colour_1,ld_c,enable,X,Y,colour_out);
endmodule

module control(clock,reset_n,go,enable,ld_c,plot);
	input clock,reset_n,go;
	output reg enable,ld_c,plot;	
	
	reg [3:0] current_state, next_state;
	
	localparam  S_LOAD_C       = 4'd0,
                S_LOAD_C_WAIT   = 4'd1,
				S_CYCLE_0        = 4'd2;
	
	always@(*)
      begin: state_table 
            case (current_state)
                S_LOAD_C: next_state = go ? S_LOAD_C_WAIT : S_LOAD_C; 
                S_LOAD_C_WAIT: next_state = go ? S_LOAD_C_WAIT : S_CYCLE_0;  
                S_CYCLE_0: next_state = S_CYCLE_0;
            default:     next_state = S_LOAD_C;
        endcase
      end 
   
	always@(*)
      begin: enable_signals
        // By default make all our signals 0
        ld_c = 1'b0;
		  enable = 1'b0;
		  plot = 1'b0;
		  
		  case(current_state)
				S_LOAD_C:begin
					end
				S_CYCLE_0:begin
				   ld_c = 1'b1;
					enable = 1'b1;
					plot = 1'b1;
					end
		  endcase
    end
	 
	 always@(posedge clock)
      begin: state_FFs
        if(!reset_n)
            current_state <= S_LOAD_C;
        else
            current_state <= next_state;
      end 
endmodule

module combined(clock,reset_n,go,colour,X,Y,Colour,plot);
	input clock,reset_n,go;
	input [2:0] colour;
	output plot;
	output [7:0] X,Y;
	output [2:0] Colour;
	
	wire ld_c,enable,plot;
	
	control m1(clock,reset_n,go,enable,ld_c,plot);
	datapath m2(enable,clock,ld_c,colour,reset_n,X,Y,Colour);

endmodule