// James Kaden Cassidy kacassidy@hmc.edu 8/31/2025

// testbench to confirm all permutations of seven segment display are correct

module testbench();

    logic clk, reset;
	logic result;
	logic [31:0] vector_num, errors;
	logic [10:0] testvectors[10000:0];

	// dut signals
    logic[3:0]  s;
    logic[2:0]  led;
    logic[6:0]  seg, expected_seg;
	
	// generate clock
	always begin
		clk=1; #5; clk=0; #5;
	end

	seven_segment_display dut(.value(s), .segments(seg));
		
	// at start of test, load vectors and pulse reset
	initial begin
		
		$readmemb("../src/seven_segment_display_testvectors.tv", testvectors);
		
		//Reset Values
		vector_num = 0; errors = 0; reset = 1; 
		
		#12; //Wait to reset
		
		reset = 0; //Begin
	end

	always @ (posedge clk) begin
		{s, expected_seg} = testvectors[vector_num];
	end
		
	// check results on falling edge of clk
	always @(negedge clk)
		if (~reset) begin // skip during reset

			//No more instructions
			if (expected_seg === 7'bxxxxxxx) begin
				$display("Total test cases %d", vector_num);
				$display("Total errors %d", errors);
				$stop;
			end

			//Check if correct result was computed
			if (expected_seg === seg) begin
				result = 1'b1;
			end else begin
				$display("Error on vector %d, %b (%b expected)", vector_num, seg, expected_seg);
				result = 1'b0;
				errors = errors + 1;
			end
			
			//next test
			vector_num = vector_num + 1;
		
		end	

endmodule