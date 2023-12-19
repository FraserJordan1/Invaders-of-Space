module DE1_SoC(CLOCK_50, KEY, SW, GPIO_1, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
	input logic CLOCK_50;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	output logic [35:0] GPIO_1; 
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	logic reset;
	logic [31:0] div_clk;
	assign reset = SW[9];
	parameter which_clk = 8;
	
	clock_divider dv(
		.clk(CLOCK_50),
		.reset,
		.divided_clocks(div_clk)
	);
	
//	logic clk_select;
//	assign clk_select = div_clk[which_clk]; // For on FPGA
//	assign clk_select = CLOCK_50; // For Simulation purposes

	// Player controls
	logic move_left, move_right, shoot;
	assign move_left = ~KEY[3];
	assign move_right = ~KEY[0];
	assign shoot = ~KEY[1];
	
	// Number of player lives and number of enemies remaining
	logic [1:0] player_lives = 2'b11;
	logic [3:0] enemy_count = 4'b1111;
	int enemy_temp_count = 0;

	seg7_display_status game_status(
		.clk(div_clk[22]),
		.reset,
		.player_lives,
		.enemy_count(enemy_temp_count),
		.HEX0, 
		.HEX1, 
		.HEX2, 
		.HEX3, 
		.HEX4, 
		.HEX5
	);
	
	logic [15:0][15:0] red_array;
	logic [15:0][15:0] green_array;

	matrix16_16driver Driver (
		.clk(clk_select),
		.reset,
		.GPIO_1,
		.red_array,
		.green_array,
		.en(1'b1)
	);
	
	// enemy flip when they win.
	int enemy_anim = 0;
	int enemy_at_player_count = 0;
	// moving player model
	int fire_travel = 14;
	int fire_pos = 7;
	int straight_shot = 7; // used for keeping the bullet straight
	int enemy_move = 0;
	int enemy_pos = 1;
	logic shot_fired = 1'b0;
	
	logic enemy_shot_fired = 1'b0;
	logic enemy_shot_initiated = 1'b0;
	int enemy_shot_point = 3;
	int enemy_straight_shot = 4;
	logic [3:0] random_value;
	always_ff @(posedge div_clk[21] or posedge reset) begin
		if (reset) begin
			// reset all LED lights
			for (int i = 0; i < 16; i++) begin
				red_array[i] <= 16'b0;
				green_array[i] <= 16'b0;
			end

			green_array[14][7] <= 1'b1;
			green_array[15][6] <= 1'b1;
			green_array[15][7] <= 1'b1;
			green_array[15][8] <= 1'b1;
			fire_pos = 7;
			fire_travel = 14;
			straight_shot = 7;
			shot_fired <= 0;
			

			enemy_move = 1;
			enemy_pos = 1;
			enemy_shot_point = 3;
			enemy_straight_shot = 4;
			enemy_shot_fired <= 0;
			random_value <= 3'b001;
			enemy_shot_initiated <= 0;
			player_lives <= 2'b11;
			enemy_count <= 4'b1111;
			LEDR[7:0] <= 0;
			LEDR[8] <= 1;
			enemy_temp_count = 0;
			
			// SPAWN ALL ENEMIES GOING TOWARDS PLAYER
			for (int i = 0; i < 4; i++) begin
				green_array[enemy_pos - 1][0 + (4 * i)] <= 1;
				green_array[enemy_pos - 1][2 + (4 * i)] <= 1;
				green_array[enemy_pos][1 + (4 * i)] <= 1;
			end
		end else if (player_lives != 2'b0 && enemy_temp_count < 1) begin
		
			// check if any enemies have made it to the player
			for (int i = 0; i < 16; i++) begin
				if (green_array[14][i]) begin
					enemy_at_player_count++;
				end
			end
			
			if (enemy_at_player_count == 2) begin
				player_lives <= 2'b00;
			end else begin
				enemy_at_player_count = 0;
			end
			
			
			LEDR[1:0] <= player_lives;
			// control player movement
			if (move_left && green_array[14][14] == 1'b0) begin
				green_array[14] <= green_array[14] << 1;
				green_array[15] <= green_array[15] << 1;
				fire_pos = fire_pos + 1;
			end else if (move_right && green_array[14][1] == 1'b0) begin
				green_array[14] <= green_array[14] >> 1;
				green_array[15] <= green_array[15] >> 1;
				fire_pos = fire_pos - 1;
			end
			
			// control firing player bullet
			if (shoot) begin
				if (shot_fired == 1'b0) begin
					straight_shot <= fire_pos;
					shot_fired <= 1'b1;
				end
			end
			if (shot_fired == 1'b1) begin
				if (fire_travel == 0) begin
					red_array[fire_travel][straight_shot] <= 0;
					shot_fired <= 1'b0;
					fire_travel = 14;
				end else if (fire_travel != 0 && green_array[fire_travel - 1][straight_shot] <= 0) begin
					red_array[fire_travel - 1][straight_shot] <= 1;
					red_array[fire_travel][straight_shot] <= 0;
					fire_travel = fire_travel - 1;
				end else if (fire_travel != 0 && green_array[fire_travel - 1][straight_shot] <= 1) begin
					red_array[fire_travel - 1][straight_shot] <= 0;
					red_array[fire_travel][straight_shot] <= 0;
					fire_travel = 14;
					shot_fired <= 1'b0;
				end
			end
			
			
			// control firing enemy bullet
			if (enemy_shot_fired == 1'b0) begin
				if (enemy_shot_initiated == 0) begin
					enemy_shot_point = enemy_pos;
					enemy_shot_initiated <= 1;
					if (random_value == 4'b0001) begin
						enemy_shot_point = 1;
						if (!green_array[enemy_pos][1]) begin
							enemy_shot_initiated <= 0;
						end
						random_value = random_value << 1;
					end else if (random_value == 4'b0010) begin
						enemy_shot_point = 9;
						if (!green_array[enemy_pos][9]) begin
							enemy_shot_initiated <= 0;
						end
						random_value = random_value << 1;
					end else if (random_value == 4'b0100) begin
						enemy_shot_point = 5;
						if (!green_array[enemy_pos][5]) begin
							enemy_shot_initiated <= 0;
						end
						random_value = random_value << 1;
					end else if (random_value == 4'b1000) begin
						enemy_shot_point = 13;
						if (!green_array[enemy_pos][13]) begin
							enemy_shot_initiated <= 0;
						end
						random_value = 4'b0001;
					end
				end 
				
				if (enemy_shot_initiated) begin
						
					red_array[enemy_straight_shot + 2][enemy_shot_point] <= 1;
					red_array[enemy_straight_shot + 1][enemy_shot_point] <= 0;
					enemy_straight_shot = enemy_straight_shot + 1; 
		
					
					if (enemy_straight_shot == 14) begin
						if (green_array[14][enemy_shot_point] == 1 || green_array[15][enemy_shot_point]) begin
							player_lives <= player_lives - 1;
						end
						red_array[enemy_straight_shot + 1][enemy_shot_point] <= 0;
						enemy_shot_fired <= 1'b0;
						enemy_shot_point = enemy_pos;
						enemy_shot_initiated <= 0;
						enemy_straight_shot = enemy_pos + 1;
					end
				end
			end
			
			for (int i = 0; i < 4; i++) begin
				if (
						red_array[enemy_pos + 1][1 + (i * 4)] 
						|| red_array[enemy_pos][i * 4] 
						|| red_array[enemy_pos][2 + (i * 4)]
					) begin
					green_array[enemy_pos][1 + (i * 4)] <= 0;
					green_array[enemy_pos - 1][0 + (i * 4)] <= 0;
					green_array[enemy_pos - 1][2 + (i * 4)] <= 0;
					enemy_count <= enemy_count - 1;
				end
			end
			
			// respawn row of enemies and check if any enemies exist
			if (green_array[enemy_pos] == 16'b0) begin
					enemy_temp_count = enemy_temp_count + 1;
					
			end

			if (enemy_move == 18) begin
				green_array[enemy_pos + 1] <= green_array[enemy_pos];
				green_array[enemy_pos] <= green_array[enemy_pos - 1];
				
				green_array[enemy_pos - 1] <= 16'b0;
				
				enemy_pos = enemy_pos + 1;
				enemy_move = 0;
			end else begin
				enemy_move = enemy_move + 1;
			end
			
			// if one of the enemies makes it to the player, player loses
			if (enemy_pos == 14) begin
				player_lives <= 0;
			end
			
		end else begin
		
			for (int i = 0; i < 15; i++) begin
				green_array[i] <= 16'b0;
				red_array[i] <= 16'b0;
			end
			
			if (player_lives == 2'b0 && enemy_temp_count < 1) begin
				// ENEMY WIN MODEL
				if (enemy_anim <= 5) begin
					red_array[0] <= 16'b0000000000000000;
					red_array[1] <= 16'b0000000000000000;
					red_array[2] <= 16'b0000000000000000;
					
					red_array[3] <= 16'b0000100000010000;
					red_array[4] <= 16'b0000010000100000;
					red_array[5] <= 16'b0000111111110000;
					red_array[6] <= 16'b0001101111011000;
					red_array[7] <= 16'b0011111111111100;
					red_array[8] <= 16'b0010111111110100;
					red_array[9] <= 16'b0010111111110100;
					red_array[10] <= 16'b0010100000010100;
					red_array[11] <= 16'b0000011001100000;
					
					red_array[12] <= 16'b0000000000000000;
					red_array[13] <= 16'b0000000000000000;
					red_array[14] <= 16'b0000000000000000;
					red_array[15] <= 16'b0000000000000000;
					
					enemy_anim = enemy_anim + 1;
				end else if (enemy_anim > 5 && enemy_anim <= 10) begin
					red_array[0] <= 16'b0000000000000000;
					red_array[1] <= 16'b0000000000000000;
					red_array[2] <= 16'b0000000000000000;
					red_array[3] <= 16'b0000000000000000;
					
					red_array[4] <= 16'b0010100000010100;
					red_array[5] <= 16'b0010010000100100;
					red_array[6] <= 16'b0010111111110100;
					red_array[7] <= 16'b0011101111011100;
					red_array[8] <= 16'b0011111111111100;
					red_array[9] <= 16'b0001111111111000;
					red_array[10] <= 16'b0000111111110000;
					red_array[11] <= 16'b0000100000010000;
					red_array[12] <= 16'b0001000000001000;
					
					red_array[13] <= 16'b0000000000000000;
					red_array[14] <= 16'b0000000000000000;
					red_array[15] <= 16'b0000000000000000;
					
					
					enemy_anim = enemy_anim + 1;
				end else begin
					enemy_anim = 0;
				end
			end else begin
				// PLAYER WIN MODEL
				if (enemy_anim <= 10) begin
					green_array[0] <= 16'b0000000000000000;
					green_array[1] <= 16'b0000000000000000;
					green_array[2] <= 16'b0000000000000000;
					
					green_array[3] <= 16'b0000100000010000;
					green_array[4] <= 16'b0000010000100000;
					green_array[5] <= 16'b0000111111110000;
					green_array[6] <= 16'b0001101111011000;
					green_array[7] <= 16'b0011111111111100;
					green_array[8] <= 16'b0010111111110100;
					green_array[9] <= 16'b0010111111110100;
					green_array[10] <= 16'b0010100000010100;
					green_array[11] <= 16'b0000011001100000;
					
					green_array[12] <= 16'b0000000000000000;
					green_array[13] <= 16'b0000000000000000;
					green_array[14] <= 16'b0000000000000000;
					green_array[15] <= 16'b0000000000000000;
					
					enemy_anim = enemy_anim + 1;
				end else if (enemy_anim > 10 && enemy_anim <= 20) begin
					green_array[0] <= 16'b0000000000000000;
					green_array[1] <= 16'b0000000000000000;
					green_array[2] <= 16'b0000000000000000;
					green_array[3] <= 16'b0000000000000000;
					
					green_array[4] <= 16'b0010100000010100;
					green_array[5] <= 16'b0010010000100100;
					green_array[6] <= 16'b0010111111110100;
					green_array[7] <= 16'b0011101111011100;
					green_array[8] <= 16'b0011111111111100;
					green_array[9] <= 16'b0001111111111000;
					green_array[10] <= 16'b0000111111110000;
					green_array[11] <= 16'b0000100000010000;
					green_array[12] <= 16'b0001000000001000;
					
					green_array[13] <= 16'b0000000000000000;
					green_array[14] <= 16'b0000000000000000;
					green_array[15] <= 16'b0000000000000000;
					
					
					enemy_anim = enemy_anim + 1;
				end else begin
					enemy_anim = 0;
				end
			end
		
		end
	end
	
endmodule


module DE1_SoC_testbench();
	reg CLOCK_50;
	reg [3:0] KEY;
	reg [9:0] SW;
	
	wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire [8:0] LEDR;
	wire [35:0] GPIO_1;
	
	wire reset = SW[9];
	wire player_moves_left = KEY[3];
	wire player_moves_right = KEY[0];
	wire player_shoots = KEY[1];
	
	DE1_SoC dut(
		.CLOCK_50(CLOCK_50),
		.KEY(KEY),
		.SW(SW),
		.GPIO_1(GPIO_1),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.LEDR(LEDR)
	);
	
	always begin
		CLOCK_50 = 0; #5;
		CLOCK_50 = 1; #5;
	end
	
	logic [15:0][15:0] red_array = GPIO_1[31:16];
	logic [15:0][15:0] green_array = GPIO_1[15:0];
	
	always #10 CLOCK_50 = ~CLOCK_50;
	
	initial begin
		CLOCK_50 = 0;
		KEY = 4'b1111;
		SW = 10'b0;
		
		// Test Case 1: Player moves to the left
		KEY[0] = 1; 
		repeat(4) @(posedge CLOCK_50);
		
		// Test Case 2: Player moves to the right
		
		KEY[0] = 0; KEY[3] = 1; repeat(4) @(posedge CLOCK_50);
	
		// Test Case 3: Player shoots
		KEY[0] = 0; KEY[1] = 1; repeat(4) @(posedge CLOCK_50);
		
		// Test Case 4: Player gets hit bullet then perishes after the third
		red_array[14][7] = 1; repeat(4);
		green_array[14][7] = 1; repeat(4);
		#10;
		red_array[14][7] = 1; repeat(4);
		green_array[14][7] = 1; repeat(4);
		#10;
		
		// Test Case 5: Player wins game
		SW[9] = 1; 
		green_array[0] = 16'b0; repeat(4); @(posedge CLOCK_50);
		green_array[1] = 16'b0; repeat(4); @(posedge CLOCK_50);
		green_array[2] = 16'b0; repeat(4); @(posedge CLOCK_50);
		green_array[3] = 16'b0; repeat(4); @(posedge CLOCK_50);
		green_array[4] = 16'b0; repeat(4); @(posedge CLOCK_50);
		green_array[5] = 16'b0; repeat(4); @(posedge CLOCK_50);
		green_array[6] = 16'b0; repeat(4); @(posedge CLOCK_50);
		green_array[7] = 16'b0; repeat(4); @(posedge CLOCK_50);
		green_array[8] = 16'b0; repeat(4); @(posedge CLOCK_50);
		green_array[9] = 16'b0; repeat(4); @(posedge CLOCK_50);
		green_array[10] = 16'b0; repeat(4); @(posedge CLOCK_50);
		green_array[11] = 16'b0; repeat(4); @(posedge CLOCK_50);
		green_array[12] = 16'b0; repeat(4); @(posedge CLOCK_50);
		green_array[13] = 16'b0; repeat(4); @(posedge CLOCK_50);
		
		// Finish simulation
		$finish;
	end


endmodule

