// used for displaying status of the game. Player Lives if ongoing, Player loses or wins
module seg7_display_status(clk, reset, player_lives, enemy_count, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input logic clk, reset;
	input logic [1:0] player_lives;
	input int enemy_count;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	always_ff @(posedge clk) begin
		if (enemy_count >= 1 && player_lives != 2'b0) begin
			// This displays when the player wins, "UdIdIt" - You did it.
			// Unable to display "U WON" on the 7 seg displays
			HEX5 <= 7'b1000001; // U
			HEX4 <= 7'b0100001; // d
			HEX3 <= 7'b1001111; // I
			HEX2 <= 7'b0100001; // d
			HEX1 <= 7'b1001111; // I
			HEX0 <= 7'b0000111; // t
		end else if (enemy_count < 1 && player_lives == 2'b00) begin
			// This displays when the player loses, "U LOSE" - You Lose.
			HEX5 <= 7'b1000001; // U
			HEX4 <= 7'b1111111; // " " (blank)
			HEX3 <= 7'b1000111; // L
			HEX2 <= 7'b1000000; // O
			HEX1 <= 7'b0010010; // S
			HEX0 <= 7'b0000110; // E
		end else if (enemy_count < 1 && player_lives != 2'b00) begin
			// Display number of lives left
			HEX5 <= 7'b1000111; // L
			HEX4 <= 7'b1001111; // I
			HEX3 <= 7'b0001110; // F	
			HEX2 <= 7'b0000110; // E
			HEX1 <= 7'b0111111; // -
			case(player_lives)
				2'b11: HEX0 <= 7'b0110000; // 3
				2'b10: HEX0 <= 7'b0100100; // 2
				2'b01: HEX0 <= 7'b1111001; // 1
				default: HEX0 <= 7'b1111111; // No lives
			endcase
		end else begin
			HEX5 <= 7'b1111111;
			HEX4 <= 7'b1111111;
			HEX3 <= 7'b1111111;
			HEX2 <= 7'b1111111;
			HEX1 <= 7'b1111111;
			HEX0 <= 7'b1111111;
		end
	end

endmodule

module seg7_display_status_testbench();
	logic CLOCK_50, reset;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	int enemy_count;
	logic [1:0] player_lives;
	
	seg7_display_status dut (
		.clk(CLOCK_50),
		.reset,
		.player_lives,
		.enemy_count,
		.HEX0,
		.HEX1,
		.HEX2,
		.HEX3,
		.HEX4,
		.HEX5
	);
	

	always #5 CLOCK_50 = ~CLOCK_50;
	initial begin
		
		// Test Case 1: Player has three lives
		enemy_count = 2; repeat(4);
		#10 player_lives <= 2'b11; repeat(4);
		HEX5 <= 7'b1000111;  repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;repeat(4);	
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);

		// Test Case 1: Player has three lives
		enemy_count = 2;repeat(4);
		#10 player_lives <= 2'b11;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);
		
				// Test Case 1: Player has three lives
		enemy_count = 2; repeat(4);
		#10 player_lives <= 2'b11; repeat(4);
		HEX5 <= 7'b1000111;  repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;repeat(4);	
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);

		// Test Case 1: Player has three lives
		enemy_count = 2;repeat(4);
		#10 player_lives <= 2'b11;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);
		
				// Test Case 1: Player has three lives
		enemy_count = 2; repeat(4);
		#10 player_lives <= 2'b11; repeat(4);
		HEX5 <= 7'b1000111;  repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;repeat(4);	
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);

		// Test Case 1: Player has three lives
		enemy_count = 2;repeat(4);
		#10 player_lives <= 2'b11;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);
		
				// Test Case 1: Player has three lives
		enemy_count = 2; repeat(4);
		#10 player_lives <= 2'b11; repeat(4);
		HEX5 <= 7'b1000111;  repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;repeat(4);	
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);

		// Test Case 1: Player has three lives
		enemy_count = 2;repeat(4);
		#10 player_lives <= 2'b11;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);
		
				// Test Case 1: Player has three lives
		enemy_count = 2; repeat(4);
		#10 player_lives <= 2'b11; repeat(4);
		HEX5 <= 7'b1000111;  repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;repeat(4);	
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);

		// Test Case 1: Player has three lives
		enemy_count = 2;repeat(4);
		#10 player_lives <= 2'b11;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);
		
				// Test Case 1: Player has three lives
		enemy_count = 2; repeat(4);
		#10 player_lives <= 2'b11; repeat(4);
		HEX5 <= 7'b1000111;  repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;repeat(4);	
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);

		// Test Case 1: Player has three lives
		enemy_count = 2;repeat(4);
		#10 player_lives <= 2'b11;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);
		
				// Test Case 1: Player has three lives
		enemy_count = 2; repeat(4);
		#10 player_lives <= 2'b11; repeat(4);
		HEX5 <= 7'b1000111;  repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;repeat(4);	
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);

		// Test Case 1: Player has three lives
		enemy_count = 2;repeat(4);
		#10 player_lives <= 2'b11;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);
		
				// Test Case 1: Player has three lives
		enemy_count = 2; repeat(4);
		#10 player_lives <= 2'b11; repeat(4);
		HEX5 <= 7'b1000111;  repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;repeat(4);	
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);

		// Test Case 1: Player has three lives
		enemy_count = 2;repeat(4);
		#10 player_lives <= 2'b11;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);
		
				// Test Case 1: Player has three lives
		enemy_count = 2; repeat(4);
		#10 player_lives <= 2'b11; repeat(4);
		HEX5 <= 7'b1000111;  repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;repeat(4);	
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);

		// Test Case 1: Player has three lives
		enemy_count = 2;repeat(4);
		#10 player_lives <= 2'b11;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);
		
				// Test Case 1: Player has three lives
		enemy_count = 2; repeat(4);
		#10 player_lives <= 2'b11; repeat(4);
		HEX5 <= 7'b1000111;  repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;repeat(4);	
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);

		// Test Case 1: Player has three lives
		enemy_count = 2;repeat(4);
		#10 player_lives <= 2'b11;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);
		
				// Test Case 1: Player has three lives
		enemy_count = 2; repeat(4);
		#10 player_lives <= 2'b11; repeat(4);
		HEX5 <= 7'b1000111;  repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;repeat(4);	
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);

		// Test Case 1: Player has three lives
		enemy_count = 2;repeat(4);
		#10 player_lives <= 2'b11;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);
		
				// Test Case 1: Player has three lives
		enemy_count = 2; repeat(4);
		#10 player_lives <= 2'b11; repeat(4);
		HEX5 <= 7'b1000111;  repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;repeat(4);	
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);

		// Test Case 1: Player has three lives
		enemy_count = 2;repeat(4);
		#10 player_lives <= 2'b11;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);
		
				// Test Case 1: Player has three lives
		enemy_count = 2; repeat(4);
		#10 player_lives <= 2'b11; repeat(4);
		HEX5 <= 7'b1000111;  repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;repeat(4);	
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);

		// Test Case 1: Player has three lives
		enemy_count = 2;repeat(4);
		#10 player_lives <= 2'b11;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0110000;repeat(4);
		
		
		// Test Case 2: Player has two lives
		#10 player_lives <= 2'b10;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b0100100;repeat(4);
		
		// Test Case 3: Player has one lives
		#10 player_lives <= 2'b01;repeat(4);
		HEX5 <= 7'b1000111;repeat(4);
		HEX4 <= 7'b1001111;repeat(4);
		HEX3 <= 7'b0001110;	repeat(4);
		HEX2 <= 7'b0000110;repeat(4);
		HEX1 <= 7'b0111111;repeat(4);
		HEX0 <= 7'b1111001;repeat(4);

		// Test Case 4: Player has no more lives and has lost
		#10 player_lives <= 2'b0;repeat(4);
		
		// Test Case 5: Player has won
		#10 player_lives <= 2'b01;repeat(4);
		#10 enemy_count = 3;repeat(4);
		
		// Finish simulation
		$finish;
	end
	
endmodule

