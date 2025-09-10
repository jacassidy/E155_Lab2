// James Kaden Cassidy kacassidy@hmc.edu 9/7/2025

// top module housing an oscillator and the logic required to both:
//      1.) selectively control inputs to the FPGA via switches to determine the values to be displayed
//      2.) logic to save the inputted values, and display them through the use of a single decoder and time multiplexing

module lab2_top (
    input   logic       rst_inverted,
    input   logic       display_input_select,
    input   logic       debug_clk,
    input   logic[3:0]  input_value,
    output  logic       display1_select,
    output  logic       display2_select,
    output  logic[6:0]  display,
    output  logic[5:0]  sum,
	output  logic       div_clk,
	output  logic       reset
 );
 
 logic          clk;
 logic          display_output_select;

 logic[3:0]     display1_value, display2_value, display_output_value;

 // default is for reset to be pulled high
 assign 		reset = ~rst_inverted;

 //// --------- segment display logic --------- ////
 
 // driving logic for selectively displaying one number at a time
 assign display_output_value =  display_output_select ? display1_value : display2_value;
 assign display1_select = display_output_select;
 assign display2_select = ~display_output_select;

 // single display controller for both displays
 seven_segment_display Display_Controller(.value(display_output_value), .segments(display));

 // Internal high-speed oscillator
 HSOSC #(.CLKHF_DIV(2'b00)) hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

 // Divider to reduce oscillator from 48Mhz to a speed not visible to the eye, but slow enough didgits are independent
	clock_divider #(.div_count(100000)) Clock_Divider(.clk(clk), .reset, .clk_divided(display_output_select));
 
 assign div_clk = display_output_select;

 //// --------- value saving logic --------- ////
 
 always_ff @ (posedge clk, debug_clk) begin
    if (reset) begin
        display1_value <= 4'b0;
        display2_value <= 4'b0;
    end else begin
        if (display_input_select) display1_value <= input_value;
        else                      display2_value <= input_value;
    end

 end

 //// --------- summing logic --------- ////

 assign sum = display1_value + display2_value;
	
endmodule
