`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2024 03:03:52 PM
// Design Name: 
// Module Name: stepper_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module stepper_test(
    input CLK100MHZ,
    input BTNU,
    output pinA,
    output pinB
    );
    
    localparam MHz = 1000000;
	localparam SYSTEM_FREQ = 100*MHz; // System clock frequency
	
    wire [17:0] counterLimit;
	assign desiredFreq = 0.01*MHz;
	assign counterLimit = (SYSTEM_FREQ / desiredFreq*2) - 1;
	
	reg clk1MHz = 0;
	reg [17:0] counter = 0;
	always @(posedge clk) begin
	   if (counter < counterLimit)
	       counter <= counter + 1;
	   else begin
	       counter <= 0;
	       clk1MHz <= ~ clk1MHz;
	   end
    end
    
    wire[6:0] duty_cycle;
    wire [6:0] max, min;
    assign max = 7'b1100100;
    assign min = 7'b0;
    assign duty_cycle = clk1MHz ? max : min;
    
    wire stepOut, dirOut;

    PWMSerializer pwmOut(clk, reset, duty_cycle, stepOut);
    assign dirOut = 1'b1; //forwards hardcoded
    
    assign pinA = clk1MHz;
    assign pinB = dirOut;
    
endmodule
