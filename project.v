/*
 * The Gladiator
 * CSCB58 Final Project 
 * Team members	:Changjin He
 *				 Yue Yin
 */

module project(
		//inputs
		CLOCK_50,
		KEY,
		SW,
		//VGA outputs
		VGA_CLK,
		VGA_HS,
		VGA_VS,
		VGA_BLANK_N,
		VGA_SYNC_N,
		VGA_R,
		VGA_G,
		VGA_B,
		//outpus
		HEX0,
		LEDG,
		LEDR
	);
	
	input CLOCK_50; 	//50 MHz
	input [15:0] SW;
	input [3:0] KEY;
	
	output VGA_CLK;
	output VGA_HS;
	output VGA_VS;
	output VGA_BLANK_N;
	output VGA_SYNC_N;
	output [9:0] VGA_R;
	output [9:0] VGA_G;
	output [9:0] VGA_B;
	output [6:0] HEX0;
	output [7:0] LEDG;
	output [15:0] LEDR;
	
	wire	[2:0] 	colour;
	wire	[8:0] 	x;
	wire	[7:0]	y;
	wire		 	plot;
	
	wire	[7:0]	KEY_p;
	wire			reset;
	
	wire	[1:0] 	play1_hp;
	wire	[1:0] 	play1_eng;
	wire	[2:0] 	play1_sel;
	wire	[1:0] 	play2_hp;
	wire	[1:0] 	play2_eng;
	wire	[2:0] 	play2_sel;	
	
	wire	[3:0]	cnt_time;
		
	key_pre key_pre_init(
		.clock(CLOCK_50),
		.KEY({SW[7:0],KEY[0]}),
		.KEY_p({KEY_p,reset}));

	game_ctrl game_ctrl_init(
		.clock(CLOCK_50),
		.reset(reset),
		.KEY_p(KEY_p),
		.LEDG(),
		.LEDR(),
		.cnt_time(cnt_time),
		.play1_hp(play1_hp),
		.play1_eng(play1_eng),
		.play1_sel(play1_sel),
		.play2_hp(play2_hp),
		.play2_eng(play2_eng),
		.play2_sel(play2_sel)	
	);

	seg7_decoder seg7_decoder_init(
		.dat_i(cnt_time),
		.seg_o(HEX0));
	
	vga_disp vga_disp_init(
		.clock(CLOCK_50),
		.play1_hp(play1_hp),
		.play1_eng(play1_eng),
		.play1_sel(play1_sel),
		.play2_hp(play2_hp),
		.play2_eng(play2_eng),
		.play2_sel(play2_sel),
		.colour(colour),
		.x(x),
		.y(y),
		.plot(plot)
		);
		
	vga_adapter VGA(
			.resetn(1'b1),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(plot),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "blank.mif";
	
		
endmodule

