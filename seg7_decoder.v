/*
 * The Gladiator
 * module		:seg7_decoder
 * Team members	:Changjin He
 *				 Yue Yin
 */


module seg7_decoder(
	dat_i,
	seg_o); 

	input	[3:0]	dat_i;				
	output	[6:0]	seg_o;						

	reg		[6:0]	seg_o;				

	always @(*)begin
		case(dat_i)				
		
			4'h0:seg_o=7'b1000000;	//displays 0
			4'h1:seg_o=7'b1111001;	//displays 1
			4'h2:seg_o=7'b0100100;	//displays 2
			4'h3:seg_o=7'b0110000;	//displays 3
			4'h4:seg_o=7'b0011001;	//displays 4
			4'h5:seg_o=7'b0010010;	//displays 5
			4'h6:seg_o=7'b0000010;	//displays 6
			4'h7:seg_o=7'b1111000;	//displays 7
			4'h8:seg_o=7'b0000000;	//displays 8
			4'h9:seg_o=7'b0011000;	//displays 9
			default:seg_o=7'b0111111;// default
		endcase
	end
	
endmodule
