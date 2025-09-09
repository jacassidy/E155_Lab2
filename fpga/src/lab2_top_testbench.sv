
// // James Kaden Cassidy kacassidy@hmc.edu 8/31/2025

// // testbench to confirm functionality of the two onboard leds controlled by the switches (housed in the top module)

// timeunit 1ns;
// timeprecision 1ps;

// module top_testbench();

//     logic clk, reset;
// 	logic result;
// 	logic [31:0] vector_num, errors;
// 	logic [10:0] testvectors[10000:0];

// 	// dut signals
//     logic[3:0]  s;
//     logic[1:0]  led, expected_led;
// 	logic 		blink_led;
//     logic[6:0]  seg;
	
// 	// generate clock
// 	always begin
// 		clk=1; #5; clk=0; #5;
// 	end

// 	lab2_top dut(.reset, .display_input_select, . input_value,
//     			.display1_select, .display2_select, .display, .sum);
		
// 	// at start of test, load vectors and pulse reset
// 	initial begin
		
// 		$readmemb("../src/lab1_top_testvectors.tv", testvectors);
		
// 		//Reset Values
// 		vector_num = 0; errors = 0; reset = 1; 
		
// 		#12; //Wait to reset
		
// 		reset = 0; //Begin
// 	end

// 	always @ (posedge clk) begin
// 		{s, expected_led} = testvectors[vector_num];
// 	end
		
// 	// check results on falling edge of clk
// 	always @(negedge clk)
// 		if (~reset) begin // skip during reset

// 			//No more instructions
// 			if (expected_led === 2'bxx) begin
// 				$display("Total test cases %d", vector_num);
// 				$display("Total errors %d", errors);
// 				$stop;
// 			end

// 			//Check if correct result was computed
// 			if (expected_led === led) begin
// 				result = 1'b1;
// 			end else begin
// 				$display("Error on vector %d, %b (%b expected)", vector_num, led, expected_led);
// 				result = 1'b0;
// 				errors = errors + 1;
// 			end
			
// 			//next test
// 			vector_num = vector_num + 1;
		
// 		end	

// endmodule