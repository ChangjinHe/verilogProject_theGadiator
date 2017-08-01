/*
 * The Gladiator
 * Team members	:Changjin He, Yue Yin
 */
 
module game_ctrl(
	//inputs
	clock,
	reset,
	KEY_p,
	//output
	LEDG,
	LEDR,
	cnt_time,
	play1_hp,
	play1_eng,
	play1_sel,
	play2_hp,
	play2_eng,
	play2_sel	
);
	input			clock;
	input			reset;
	input	[7:0]	KEY_p;
	output	[7:0]	LEDG;
	output	[15:0]	LEDR;
	output	[3:0]	cnt_time;
	output	[1:0] 	play1_hp;
	output	[1:0] 	play1_eng;
	output	[2:0] 	play1_sel;
	output	[1:0] 	play2_hp;
	output	[1:0] 	play2_eng;
	output	[2:0] 	play2_sel;	


	reg		[3:0]	cnt_time	=4'h10;
	reg		[1:0] 	play1_hp	=3;
	reg		[1:0] 	play1_eng	=1;
	reg		[2:0] 	play1_sel	=1;
	reg		[1:0] 	play2_hp	=3;
	reg		[1:0] 	play2_eng	=1;
	reg		[2:0] 	play2_sel	=1;	
	
	parameter 		IDLE 		= 7'b0000001,
					S1	 		= 7'b0000010,
					S2	 		= 7'b0000100,
					S3	 		= 7'b0001000,
					S4	 		= 7'b0010000,
					S5	 		= 7'b0100000,
					OVER		= 7'b1000000;
					
	reg		[6:0]	next_state	=IDLE;
	reg		[1:0]	flag_win	=2'b00;
	
	

//	always@(posedge clock)begin
//		if(reset==1)begin
//			cur_state<=S1;
//		end
//		else begin
//			cur_state<=next_state;
//		end
//	end
	
	reg	[39:0]	cnt_10s	=40'd500000000;
	reg	[39:0]	cnt_delay =0;
	
	reg	[3:0]	play1_sel_pre=0;
	reg	[3:0]	play2_sel_pre=0;
	
	assign	LEDG	=next_state;
	assign	LEDR	={play1_sel_pre,play2_sel_pre};	
	
	reg	[1:0]	play1_hp_add=0;
	reg	[1:0]	play1_hp_dec=0;
	
	reg	[1:0]	play2_hp_add=0;
	reg	[1:0]	play2_hp_dec=0;
	
	always@(posedge clock)begin
		case(next_state)
			IDLE : begin
				if(reset==1)begin
					next_state		<=S1;
					cnt_10s			<=40'd500000000;
					play1_sel_pre	<=0;
					play2_sel_pre	<=0;
					play1_sel		<=1;
					play2_sel		<=1;
					play1_hp		<=3;
					play1_eng		<=1;
					play2_hp		<=3;
					play2_eng		<=1;
				end
				else begin
					next_state<=IDLE;
				end
				cnt_time<=10;
			end
			S1 : begin	//initial state, move to state 2 when player selected movement
				if(reset==1)begin
					next_state		<=S1;
					cnt_10s			<=40'd500000000;
					play1_sel_pre	<=0;
					play2_sel_pre	<=0;
					play1_sel		<=1;
					play2_sel		<=1;
					play1_hp		<=3;
					play1_eng		<=1;
					play2_hp		<=3;
					play2_eng		<=1;
				end				
				else if(cnt_10s>0)begin
					if(play1_sel_pre>0 || play2_sel_pre>0)begin //One Player selected his movement
						cnt_10s	<=cnt_10s-1;
					end
					if(KEY_p[7:4] != 4'b0000)begin 				//Player_1 selected his movement
						if(play1_sel_pre==0)begin
							case(KEY_p[7:4])
								4'b0001: play1_sel_pre<=4'd1;
								4'b0010: play1_sel_pre<=4'd2;
								4'b0100: play1_sel_pre<=4'd3;
								4'b1000: play1_sel_pre<=4'd4;
								default: play1_sel_pre<=play1_sel_pre;
							endcase
						end
						else begin
							play1_sel_pre<=play1_sel_pre;
						end
					end
					else if(KEY_p[3:0] != 4'b0000)begin			//Player_2 selected his movement
						if(play2_sel_pre==0)begin
							case(KEY_p[3:0])
								4'b0001: play2_sel_pre<=4'd1;
								4'b0010: play2_sel_pre<=4'd2;
								4'b0100: play2_sel_pre<=4'd3;
								4'b1000: play2_sel_pre<=4'd4;
								default: play2_sel_pre<=play2_sel_pre;
							endcase
						end
						else begin
							play2_sel_pre<=play2_sel_pre;
						end
					end					
					else begin
						play1_sel_pre<=play1_sel_pre;
						play2_sel_pre<=play2_sel_pre;
					end
					if(play1_sel_pre>0 && play2_sel_pre>0)begin //if both players selected their movements,
						next_state<=S2;							//move to state 2
						cnt_delay<=0;
					end
					else begin
						next_state<=S1;
					end
				end
				else if(play1_sel_pre>0 || play2_sel_pre>0)begin //10s time's up
					next_state<=S2;								 //move to state
				end
				else begin
					next_state<=S1;
				end
				cnt_time<=cnt_10s/50000000;
			end				
			S2 : begin	//state 2, process the time out problem£¬ move to state 3 
				if(play1_sel_pre==0)begin
					play1_sel_pre<=(play1_sel==5) ? 2 : play1_sel;
				end
				else begin
					play1_sel_pre<=play1_sel_pre;
				end
				if(play2_sel_pre==0)begin
					play2_sel_pre<=(play2_sel==5) ? 2 : play2_sel;
				end				
				else begin
					play2_sel_pre<=play2_sel_pre;
				end				
				next_state<=S3;
				play1_hp_add<=0;
				play1_hp_dec<=0;
				play2_hp_add<=0;
				play2_hp_dec<=0;
				cnt_time<=10;				
			end
			S3 : begin
				if(play1_sel_pre==1)begin			//Player_1 charged
					if(play1_eng<3)begin			//Did not execeed the maximum energy
						play1_eng<=play1_eng+1;
					end
					else begin
						play1_eng<=play1_eng;		//execeed the maximum energy
					end
					play1_sel	<=1;
					play1_hp_add<=0;
					play2_hp_dec<=0;
				end
				else if(play1_sel_pre==2)begin		//Player_1 attack
					if(play1_eng>1)begin
						play1_eng<=play1_eng-2;
						play1_sel<=5;
						play1_hp_add<=2;
						play2_hp_dec<=2;
					end
					else if(play1_eng>0)begin
						play1_eng<=play1_eng-1;
						play1_sel<=2;
						play1_hp_add<=1;
						play2_hp_dec<=1;
					end
					else begin
						play1_eng<=play1_eng+1;
						play1_sel<=1;
						play1_hp_add<=0;
						play2_hp_dec<=0;
					end
				end				
				else if(play1_sel_pre==3)begin
					if(play1_eng>0)begin
						play1_eng<=play1_eng-1;
						play1_sel<=3;
						play1_hp_add<=2;
						play2_hp_dec<=0;
					end
					else begin
						play1_eng<=play1_eng+1;
						play1_sel<=1;
						play1_hp_add<=0;
						play2_hp_dec<=0;
					end
				end
				else if(play1_sel_pre==4)begin
					play1_eng<=play1_eng;
					play1_sel<=4;
					play1_hp_add<=1;
					play2_hp_dec<=0;
				end				
				else begin
					play1_eng<=play1_eng;
					play1_sel<=1;
					play1_hp_add<=0;
					play2_hp_dec<=0;					
				end

				if(play2_sel_pre==1)begin
					if(play2_eng<3)begin
						play2_eng<=play2_eng+1;
					end
					else begin
						play2_eng<=play2_eng;
					end
					play2_sel	<=1;
					play2_hp_add<=0;
					play1_hp_dec<=0;
				end
				else if(play2_sel_pre==2)begin
					if(play2_eng>1)begin
						play2_eng<=play2_eng-2;
						play2_sel<=5;
						play2_hp_add<=2;
						play1_hp_dec<=2;
					end
					else if(play2_eng>0)begin
						play2_eng<=play2_eng-1;
						play2_sel<=2;
						play2_hp_add<=1;
						play1_hp_dec<=1;
					end
					else begin
						play2_eng<=play2_eng+1;
						play2_sel<=1;
						play2_hp_add<=0;
						play1_hp_dec<=0;
					end
				end				
				else if(play2_sel_pre==3)begin
					if(play2_eng>0)begin
						play2_eng<=play2_eng-1;
						play2_sel<=3;
						play2_hp_add<=2;
						play1_hp_dec<=0;
					end
					else begin
						play2_eng<=play2_eng+1;
						play2_sel<=1;
						play2_hp_add<=0;
						play1_hp_dec<=0;
					end
				end
				else if(play1_sel_pre==4)begin
					play2_eng<=play2_eng;
					play2_sel<=4;
					play2_hp_add<=1;
					play1_hp_dec<=0;
				end				
				else begin
					play2_eng<=play2_eng;
					play2_sel<=1;
					play2_hp_add<=0;
					play1_hp_dec<=0;					
				end				
				next_state	<=S4;
				cnt_delay	<=0;
			end
			S4 : begin
				if(play1_hp_add==2)begin
					play1_hp<=play1_hp;
				end
				else if(play1_hp_add==1)begin
					if(play1_hp_dec>1)begin
						if(play1_hp>0)begin
							play1_hp<=play1_hp-1;
						end
						else begin
							play1_hp<=0;
						end
					end
					else begin
						play1_hp<=play1_hp;
					end
				end	
				else if(play1_hp_add==0)begin
					if(play1_hp_dec>1)begin
						if(play1_hp>1)begin
							play1_hp<=play1_hp-2;
						end
						else begin
							play1_hp<=0;
						end
					end
					else if(play1_hp_dec>0)begin
						if(play1_hp>0)begin
							play1_hp<=play1_hp-1;
						end
						else begin
							play1_hp<=0;
						end
					end					
					else begin
						play1_hp<=play1_hp;
					end
				end	

				if(play2_hp_add==2)begin
					play2_hp<=play2_hp;
				end
				else if(play2_hp_add==1)begin
					if(play2_hp_dec>1)begin
						if(play2_hp>0)begin
							play2_hp<=play2_hp-1;
						end
						else begin
							play2_hp<=0;
						end
					end
					else begin
						play2_hp<=play2_hp;
					end
				end	
				else if(play2_hp_add==0)begin
					if(play2_hp_dec>1)begin
						if(play2_hp>1)begin
							play2_hp<=play2_hp-2;
						end
						else begin
							play2_hp<=0;
						end
					end
					else if(play2_hp_dec>0)begin
						if(play2_hp>0)begin
							play2_hp<=play2_hp-1;
						end
						else begin
							play2_hp<=0;
						end
					end					
					else begin
						play2_hp<=play2_hp;
					end
				end
				next_state	<=S5;
				cnt_time<=10;
			end
			S5:begin
				if(play1_hp==0 && play2_hp==0)begin
					flag_win	<=2'b00;
					next_state	<=OVER;					
				end
				else if(play1_hp==0)begin
					flag_win	<=2'b01;
					next_state	<=OVER;
				end
				else if(play2_hp==0)begin
					flag_win	<=2'b10;
					next_state	<=OVER;
				end
				else begin
					next_state		<=S1;
					cnt_10s			<=40'd500000000;
					play1_sel_pre	<=0;
					play2_sel_pre	<=0;				
				end
				cnt_time<=10;	
			end			
			OVER:begin
				if(flag_win==2'b00)begin
					play1_sel<=7;
					play2_sel<=7;
				end
				else if(flag_win==2'b10)begin
					play1_sel<=6;
					play2_sel<=7;
				end
				else if(flag_win==2'b01)begin
					play1_sel<=7;
					play2_sel<=6;
				end
				else begin
					play1_sel<=0;
					play2_sel<=0;					
				end
				if(reset==1)begin
					next_state		<=S1;
					cnt_10s			<=40'd500000000;
					play1_sel_pre	<=0;
					play2_sel_pre	<=0;
					play1_sel		<=1;
					play2_sel		<=1;
					play1_hp		<=3;
					play1_eng		<=1;
					play2_hp		<=3;
					play2_eng		<=1;
				end
				else begin
					next_state<=OVER;
				end
				cnt_time<=10;			
			end
		endcase
	end	
	
endmodule


