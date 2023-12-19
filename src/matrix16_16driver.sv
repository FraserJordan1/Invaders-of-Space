module matrix16_16driver #(parameter FREQDIV = 0) (clk, reset, GPIO_1, red_array, green_array, en);
	output logic [35:0] GPIO_1;
	input logic [15:0][15:0] red_array;
	input logic [15:0][15:0] green_array;
	input logic en, clk, reset;

	logic [(FREQDIV + 3):0] counter;
	logic [3:0] sel;
	assign sel = counter[(FREQDIV + 3):FREQDIV];

	always_ff @(posedge clk) begin
		if (reset) begin
			counter <= 1'b0;
		end else if (en) begin
			counter <= counter + 1'b1;
		end
	end

	assign GPIO_1[35:32] = sel;
	assign GPIO_1[31:16] = { 
		green_array[sel][0], 
		green_array[sel][1], 
		green_array[sel][2], 
		green_array[sel][3], 
		green_array[sel][4], 
		green_array[sel][5], 
		green_array[sel][6], 
		green_array[sel][7], 
		green_array[sel][8], 
		green_array[sel][9], 
		green_array[sel][10], 
		green_array[sel][11], 
		green_array[sel][12], 
		green_array[sel][13], 
		green_array[sel][14], 
		green_array[sel][15] 
	};
	assign GPIO_1[15:0] = { 
		red_array[sel][0], 
		red_array[sel][1], 
		red_array[sel][2], 
		red_array[sel][3], 
		red_array[sel][4], 
		red_array[sel][5], 
		red_array[sel][6], 
		red_array[sel][7], 
		red_array[sel][8], 
		red_array[sel][9], 
		red_array[sel][10], 
		red_array[sel][11], 
		red_array[sel][12], 
		red_array[sel][13], 
		red_array[sel][14], 
		red_array[sel][15] 
	};
	
endmodule

// WRITE THIS OVER AGAIN
module matrix16_16driver_testbench();
	localparam FREQDIV = 4;
	
	logic clk, reset, en;
	logic [15:0][15:0] red_array, green_array;
	
	logic [35:0] GPIO_1;
	
	matrix16_16driver #(.FREQDIV(FREQDIV)) uut (
		.clk,
		.reset,
		.en,
		.red_array,
		.green_array,
		.GPIO_1
	);
	
	always #5 clk = ~clk;
	
	
	initial begin
		// Initialize Signals
		clk = 0;
		reset = 1;
		en = 0;
		red_array = 0;
		green_array = 0;
		
		

		// Reset the system
		#10;
		reset = 0;

		// Enable the system
		#10;
		en = 1;

		// Define test values for red_array and green_array
		red_array = 16'hAAAA;   // Example pattern
		green_array = 16'h5555; // Example pattern

		// Simulate for a certain duration and then finish
		#1000;
		$finish;
	end

endmodule

