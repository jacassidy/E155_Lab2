
// James Kaden Cassidy kacassidy@hmc.edu 9/9/2025

// testbench to confirm functionality of the onboard summation of the two didgits displayed on the seven-segment displays

timeunit 1ns;
timeprecision 1ps;

module top_testbench();

    logic clk, reset;
    logic doubletime_clk;
	logic result;
	logic [31:0] vector_num, errors;
	logic [12:0] testvectors[10000:0];

    logic line_break;

    assign line_break = 1'bx;

	// dut signals
    logic[3:0] value1, value2;
    logic[4:0] sum, expected_sum;
    logic      display_select;

    logic display1_select, display2_select;
    logic[6:0] display;
    logic div_clk;
    logic fake_reset;

    logic every_other;
	
	// generate clock
	always begin
		clk=1;
        doubletime_clk = 1;
        #2;
        doubletime_clk = 0;
        #3;
        doubletime_clk = 1;
        clk=0; 
        #2;
        doubletime_clk = 0;
        #3;
	end

	lab2_top dut(.debug_clk(doubletime_clk), .rst_inverted(~reset), .display_input_select(display_select), .input_value(display_select ? value1 : value2),
                    .display1_select, .display2_select, .display, .sum, .div_clk, .reset(fake_reset));
		
	// at start of test, load vectors and pulse reset
	initial begin
		for (int j = 0; j < (1 << 4); j++) begin
		    for (int i = 0; i < (1 << 4); i++) begin
                testvectors[(i<<4) + j] = {5'(i + j), 4'(i), 4'(j)};
            end
        end
		
		//Reset Values
		vector_num = 0; errors = 0; reset = 1; 
        every_other = 1'b1;
		
		#12; //Wait to reset
		
		reset = 0; //Begin
	end

    always_ff @ (posedge doubletime_clk) begin
        if (reset)  display_select <= 1'b0;
        else        display_select <= ~display_select;
    end

	always @ (posedge doubletime_clk) begin
        if(~every_other) {expected_sum, value1, value2} = testvectors[vector_num];
	end
		
	// check results on falling edge of clk
	always @(negedge doubletime_clk) begin
        every_other = ~every_other;
    end
    always @ (negedge clk) 
		if (~reset) begin // skip during reset
            
            // if (every_other) begin
                //No more instructions
                if (expected_sum === 5'bxxxxx) begin
                    $display("Total test cases %d", vector_num);
                    $display("Total errors %d", errors);
                    $stop;
                end

                //Check if correct result was computed
                if (expected_sum === sum) begin
                    result = 1'b1;
                end else begin
                    $display("Error on vector %d, %b + %b = %b (%b expected)", vector_num, value1, value2, sum, expected_sum);
                    result = 1'bx;
                    errors = errors + 1;
                end
                
                //next test
                vector_num = vector_num + 1;
            end
		// end	

endmodule
