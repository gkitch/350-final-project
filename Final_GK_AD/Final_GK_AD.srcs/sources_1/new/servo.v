`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2024 01:23:34 PM
// Design Name: 
// Module Name: servo
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


module servo(
    input clock,
    input [31:0] servoControl,
    output reg servoPWM
    );
    
    wire clk;
    
    assign clk = clock;
    
    wire [22:0] stepCounterLimit, lowLimit, penUpLimit, penDownLimit;
    //for transition to x, y would have separate files controlling each movement
	assign stepCounterLimit = 2000000;
	assign penUpLimit = 150000;
	assign penDownLimit = 100000;
	assign lowLimit = (servoControl == 32'b0) ? penDownLimit : penUpLimit;
	
	reg clk1MHz = 0;
	reg [22:0] stepCounter = 0;
	always @(posedge clk) begin
	   if (stepCounter < lowLimit) begin
	       //set servoPWM to 1
	       //add 1 to stepCounter
	       servoPWM <= 1;
	       stepCounter <= stepCounter + 1;	       
	   end else if (stepCounter < stepCounterLimit) begin
	       stepCounter <= stepCounter + 1;
	       //set servoPWM to low (0)
	       servoPWM <= 0;
	   end else begin
	       stepCounter <= 0;
	   end
    end
   
endmodule
