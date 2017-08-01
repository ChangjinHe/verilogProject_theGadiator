/*
 * The Gladiator
 * module		:seg7_decoder
 * Team members	:Changjin He
 *				 Yue Yin
 */

module vga_disp(
	clock,
	play1_hp,
	play1_eng,
	play1_sel,
	play2_hp,
	play2_eng,
	play2_sel,
	colour,
	x,
	y,
	plot
	);
	input			clock;
	input	[1:0] 	play1_hp;
	input	[1:0] 	play1_eng;
	input	[2:0] 	play1_sel;
	input	[1:0] 	play2_hp;
	input	[1:0] 	play2_eng;
	input	[2:0] 	play2_sel;	
	output	[2:0] 	colour;
	output 	[8:0] 	x;
	output 	[7:0]	y;
	output			plot=0;
	
	reg		[2:0] 	colour;
	reg 	[8:0] 	x;
	reg 	[7:0]	y;
	reg				plot=0;
	
	reg [13:0]	addr_play1;
	wire 		colour_play1_a1;
	rom_a rom_play1_a1(
		.address(addr_play1),
		.clock(clock),
		.q(colour_play1_a1));
	defparam rom_play1_a1.BACKGROUND_IMAGE = "rom_a1.mif";
	
	wire 		colour_play1_a2;
	rom_a rom_play1_a2(
		.address(addr_play1),
		.clock(clock),
		.q(colour_play1_a2));
	defparam rom_play1_a2.BACKGROUND_IMAGE = "rom_a2.mif";	

	wire 		colour_play1_a3;
	rom_a rom_play1_a3(
		.address(addr_play1),
		.clock(clock),
		.q(colour_play1_a3));
	defparam rom_play1_a3.BACKGROUND_IMAGE = "rom_a3.mif";	
	
	wire 		colour_play1_a4;
	rom_a rom_play1_a4(
		.address(addr_play1),
		.clock(clock),
		.q(colour_play1_a4));
	defparam rom_play1_a4.BACKGROUND_IMAGE = "rom_a4.mif";		
	
	wire 		colour_play1_a5;
	rom_a rom_play1_a5(
		.address(addr_play1),
		.clock(clock),
		.q(colour_play1_a5));
	defparam rom_play1_a5.BACKGROUND_IMAGE = "rom_a5.mif";

	wire 		colour_play1_a6;
	rom_a rom_play1_a6(
		.address(addr_play1),
		.clock(clock),
		.q(colour_play1_a6));
	defparam rom_play1_a6.BACKGROUND_IMAGE = "rom_W.mif";

	wire 		colour_play1_a7;
	rom_a rom_play1_a7(
		.address(addr_play1),
		.clock(clock),
		.q(colour_play1_a7));
	defparam rom_play1_a7.BACKGROUND_IMAGE = "rom_L.mif";
	

	reg [13:0]	addr_play2;
	reg [13:0]	addr_play2_2;
	wire 		colour_play2_a1;
	rom_a rom_play2_a1(
		.address(addr_play2_2),
		.clock(clock),
		.q(colour_play2_a1));
	defparam rom_play2_a1.BACKGROUND_IMAGE = "rom_a1.mif";
	
	wire 		colour_play2_a2;
	rom_a rom_play2_a2(
		.address(addr_play2_2),
		.clock(clock),
		.q(colour_play2_a2));
	defparam rom_play2_a2.BACKGROUND_IMAGE = "rom_a2.mif";	

	wire 		colour_play2_a3;
	rom_a rom_play2_a3(
		.address(addr_play2),
		.clock(clock),
		.q(colour_play2_a3));
	defparam rom_play2_a3.BACKGROUND_IMAGE = "rom_a3.mif";	
	
	wire 		colour_play2_a4;
	rom_a rom_play2_a4(
		.address(addr_play2),
		.clock(clock),
		.q(colour_play2_a4));
	defparam rom_play2_a4.BACKGROUND_IMAGE = "rom_a4.mif";		
	
	wire 		colour_play2_a5;
	rom_a rom_play2_a5(
		.address(addr_play2),
		.clock(clock),
		.q(colour_play2_a5));
	defparam rom_play2_a5.BACKGROUND_IMAGE = "rom_a5.mif";

	wire 		colour_play2_a6;
	rom_a rom_play2_a6(
		.address(addr_play2_2),
		.clock(clock),
		.q(colour_play2_a6));
	defparam rom_play2_a6.BACKGROUND_IMAGE = "rom_W.mif";

	wire 		colour_play2_a7;
	rom_a rom_play2_a7(
		.address(addr_play2_2),
		.clock(clock),
		.q(colour_play2_a7));
	defparam rom_play2_a7.BACKGROUND_IMAGE = "rom_L.mif";
	
	always@(posedge clock)begin
		if(x<319)begin								
			x<=x+1;
			y<=y;
		end
		else if(y<239)begin
			x<=0;
			y<=y+1;
		end
		else begin
			x<=0;
			y<=0;	
		end
	end
	
	always@(posedge clock)begin
		if(x<142 && x>=92 && y<215 && y>=115)begin
			addr_play1<=(x-92)+(y-115)*50;
		end
		else if(x<222 && x>=172 && y<215 && y>=115)begin
			addr_play2<=(221-x)+(y-115)*50;
			addr_play2_2<=(x-172)+(y-115)*50;
		end		
		else begin
			addr_play1<=0;
			addr_play2<=0;
			addr_play2_2<=0;
		end
	end
	
	always@(*)begin
		if(x<70 && x>=20 && y<20 && y>=5)begin
			plot<=1'b1;
		end
		else if(x<80 && x>=30 && y<40 && y>=25)begin
			plot<=1'b1;
		end	
		else if(x<310 && x>=260 && y<20 && y>=5)begin
			plot<=1'b1;
		end
		else if(x<320 && x>=270 && y<40 && y>=25)begin
			plot<=1'b1;
		end
		else if(x<142 && x>=92 && y<215 && y>=115)begin
			plot<=1'b1;
		end
		else if(x<222 && x>=172 && y<215 && y>=115)begin
			plot<=1'b1;
		end		
		else begin
			plot<=1'b0;
		end
	end
	
	always@(*)begin
		if(x<70 && x>=20 && y<20 && y>=5)begin
			case(play1_hp)
			2'b00:begin
				if((x-30)*(x-30)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end
				else if((x-45)*(x-45)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end	
				else if((x-60)*(x-60)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end							
				else begin
					colour<=3'b111;
				end
			end
			2'b01:begin
				if((x-30)*(x-30)+(y-12)*(y-12)<25)begin
					colour<=3'b100;
				end
				else if((x-45)*(x-45)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end	
				else if((x-60)*(x-60)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end							
				else begin
					colour<=3'b111;
				end
			end
			2'b10:begin
				if((x-30)*(x-30)+(y-12)*(y-12)<25)begin
					colour<=3'b100;
				end
				else if((x-45)*(x-45)+(y-12)*(y-12)<25)begin
					colour<=3'b100;
				end	
				else if((x-60)*(x-60)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end							
				else begin
					colour<=3'b111;
				end
			end
			2'b11:begin
				if((x-30)*(x-30)+(y-12)*(y-12)<25)begin
					colour<=3'b100;
				end
				else if((x-45)*(x-45)+(y-12)*(y-12)<25)begin
					colour<=3'b100;
				end	
				else if((x-60)*(x-60)+(y-12)*(y-12)<25)begin
					colour<=3'b100;
				end							
				else begin
					colour<=3'b111;
				end
			end
			default:begin
				if((x-30)*(x-30)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end
				else if((x-45)*(x-45)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end	
				else if((x-60)*(x-60)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end						
				else begin
					colour<=3'b111;
				end
			end
			endcase							
		end
		else if(x<80 && x>=30 && y<40 && y>=25)begin
			case(play1_eng)
			2'b00:begin
				if((x-40)*(x-40)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end
				else if((x-55)*(x-55)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end	
				else if((x-70)*(x-70)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end							
				else begin
					colour<=3'b111;
				end
			end
			2'b01:begin
				if((x-40)*(x-40)+(y-32)*(y-32)<25)begin
					colour<=3'b100;
				end
				else if((x-55)*(x-55)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end	
				else if((x-70)*(x-70)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end							
				else begin
					colour<=3'b111;
				end
			end
			2'b10:begin
				if((x-40)*(x-40)+(y-32)*(y-32)<25)begin
					colour<=3'b100;
				end
				else if((x-55)*(x-55)+(y-32)*(y-32)<25)begin
					colour<=3'b100;
				end	
				else if((x-70)*(x-70)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end							
				else begin
					colour<=3'b111;
				end
			end
			2'b11:begin
				if((x-40)*(x-40)+(y-32)*(y-32)<25)begin
					colour<=3'b100;
				end
				else if((x-55)*(x-55)+(y-32)*(y-32)<25)begin
					colour<=3'b100;
				end	
				else if((x-70)*(x-70)+(y-32)*(y-32)<25)begin
					colour<=3'b100;
				end						
				else begin
					colour<=3'b111;
				end
			end
			default:begin
				if((x-40)*(x-40)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end
				else if((x-55)*(x-55)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end	
				else if((x-70)*(x-70)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end					
				else begin
					colour<=3'b111;
				end
			end
			endcase							
		end
		else if(x<310 && x>=260 && y<20 && y>=5)begin
			case(play2_hp)
			2'b00:begin
				if((x-270)*(x-270)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end
				else if((x-285)*(x-285)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end	
				else if((x-300)*(x-300)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end							
				else begin
					colour<=3'b111;
				end
			end
			2'b01:begin
				if((x-270)*(x-270)+(y-12)*(y-12)<25)begin
					colour<=3'b100;
				end
				else if((x-285)*(x-285)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end	
				else if((x-300)*(x-300)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end							
				else begin
					colour<=3'b111;
				end
			end
			2'b10:begin
				if((x-270)*(x-270)+(y-12)*(y-12)<25)begin
					colour<=3'b100;
				end
				else if((x-285)*(x-285)+(y-12)*(y-12)<25)begin
					colour<=3'b100;
				end	
				else if((x-300)*(x-300)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end							
				else begin
					colour<=3'b111;
				end
			end
			2'b11:begin
				if((x-270)*(x-270)+(y-12)*(y-12)<25)begin
					colour<=3'b100;
				end
				else if((x-285)*(x-285)+(y-12)*(y-12)<25)begin
					colour<=3'b100;
				end	
				else if((x-300)*(x-300)+(y-12)*(y-12)<25)begin
					colour<=3'b100;
				end						
				else begin
					colour<=3'b111;
				end
			end
			default:begin
				if((x-270)*(x-270)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end
				else if((x-285)*(x-285)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end	
				else if((x-300)*(x-300)+(y-12)*(y-12)<25)begin
					colour<=3'b000;
				end					
				else begin
					colour<=3'b111;
				end
			end
			endcase							
		end
		else if(x<320 && x>=270 && y<40 && y>=25)begin
			case(play2_eng)
			2'b00:begin
				if((x-280)*(x-280)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end
				else if((x-295)*(x-295)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end
				else if((x-310)*(x-310)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end
				else begin
					colour<=3'b111;
				end
			end
			2'b01:begin
				if((x-280)*(x-280)+(y-32)*(y-32)<25)begin
					colour<=3'b100;
				end
				else if((x-295)*(x-295)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end
				else if((x-310)*(x-310)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end
				else begin
					colour<=3'b111;
				end
			end
			2'b10:begin
				if((x-280)*(x-280)+(y-32)*(y-32)<25)begin
					colour<=3'b100;
				end
				else if((x-295)*(x-295)+(y-32)*(y-32)<25)begin
					colour<=3'b100;
				end
				else if((x-310)*(x-310)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end
				else begin
					colour<=3'b111;
				end
			end
			2'b11:begin
				if((x-280)*(x-280)+(y-32)*(y-32)<25)begin
					colour<=3'b100;
				end
				else if((x-295)*(x-295)+(y-32)*(y-32)<25)begin
					colour<=3'b100;
				end
				else if((x-310)*(x-310)+(y-32)*(y-32)<25)begin
					colour<=3'b100;
				end
				else begin
					colour<=3'b111;
				end
			end
			default:begin
				if((x-280)*(x-280)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end
				else if((x-295)*(x-295)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end	
				else if((x-310)*(x-310)+(y-32)*(y-32)<25)begin
					colour<=3'b000;
				end				
				else begin
					colour<=3'b111;
				end
			end
			endcase							
		end		
		else if(x<142 && x>=92 && y<215 && y>=115)begin
			case(play1_sel)
				3'd1:colour<={3{colour_play1_a1}};
				3'd2:colour<={3{colour_play1_a3}};
				3'd3:colour<={3{colour_play1_a4}};
				3'd4:colour<={3{colour_play1_a2}};
				3'd5:colour<={3{colour_play1_a5}};
				3'd6:begin
					if(colour_play1_a6==1)
						colour<=3'b111;
					else
						colour<=3'b100;
				end
				3'd7:begin
					if(colour_play1_a7==1)
						colour<=3'b111;
					else
						colour<=3'b100;
				end
				default:colour<=3'b111;
			endcase
		end
		else if(x<222 && x>=172 && y<215 && y>=115)begin
			case(play2_sel)
				3'd1:colour<={3{colour_play2_a1}};
				3'd2:colour<={3{colour_play2_a3}};
				3'd3:colour<={3{colour_play2_a4}};
				3'd4:colour<={3{colour_play2_a2}};
				3'd5:colour<={3{colour_play2_a5}};
				3'd6:begin
					if(colour_play2_a6==1)
						colour<=3'b111;
					else
						colour<=3'b100;
				end
				3'd7:begin
					if(colour_play2_a7==1)
						colour<=3'b111;
					else
						colour<=3'b100;
				end
				default:colour<=3'b111;
			endcase		
		end
		else begin
			colour<=3'b000;
		end
	end	
	
		
endmodule

