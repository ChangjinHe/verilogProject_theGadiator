/*
 * The Gladiator
 * Team members	:Changjin He, Yue Yin
 */
 
module key_pre(
	clock,
	KEY,
	KEY_p);

	parameter WITCH = 9;
	
	input				clock;		
	input	[WITCH-1:0]	KEY;		
	output	[WITCH-1:0]	KEY_p;		

	reg		[WITCH-1:0]	KEY_p=0;		
	reg		[WITCH-1:0]	KEY_q=0;		
	reg		[WITCH-1:0]	KEY_d1=0;		
	reg		[WITCH-1:0]	KEY_d2=0;		
	reg		[29:0]		cnt_20ms=0;		
	reg					clock_20ms=0;	
	
	always@(posedge clock) begin
		if(cnt_20ms<500000)			
			cnt_20ms<=cnt_20ms+1;	
		else begin					
			clock_20ms<=~clock_20ms;
			cnt_20ms<=0;
		end
	end	
	
	
	//elimination buffeting of keystroke			
	always@(posedge clock_20ms)	begin
		KEY_d1<=KEY;				
		KEY_d2<=KEY | KEY_d1;		
	end

	//edge detection
	always@(posedge clock)	begin
		KEY_q<=KEY_d2;				
		KEY_p<=~KEY_d2 &(KEY_q);	
	end
	
endmodule





