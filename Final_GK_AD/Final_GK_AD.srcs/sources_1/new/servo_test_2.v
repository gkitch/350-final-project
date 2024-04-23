`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2024 06:17:24 PM
// Design Name: 
// Module Name: servo_test_2
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


module servo_test_2(
    input CLK100MHZ,
    output reg pin_servo,
    input BTNU,
    input BTND,
    input BTNR,
    input BTNL,
    input BTNC,
    input [15:0] SW,
    output pin_XSpeed,
    output pin_XDir,
    output pin_YSpeed,
    output pin_YDir,
    output [15:0] LED
    );
    
    assign pin_XSpeed = 0;
    assign pin_XDir = 0;
    assign pin_YDir = 0;
    assign pin_YSpeed = 0;
    assign LED = 16'b0;
    
    wire clk;
    
    assign clk = CLK100MHZ;
    
    wire [22:0] stepCounterLimit, lowLimit, penUpLimit, penDownLimit;
    //for transition to x, y would have separate files controlling each movement
	assign stepCounterLimit = 2000000;
	assign penUpLimit = 100000;
	assign penDownLimit = 150000;
	assign lowLimit = (SW[15] == 0) ? penDownLimit : penUpLimit;
	
	reg clk1MHz = 0;
	reg [22:0] stepCounter = 0;
	always @(posedge clk) begin
	   if (stepCounter < lowLimit) begin
	       //set servoPWM to 1
	       //add 1 to stepCounter
	       pin_servo <= 1;
	       stepCounter <= stepCounter + 1;	       
	   end else if (stepCounter < stepCounterLimit) begin
	       stepCounter <= stepCounter + 1;
	       //set servoPWM to low (0)
	       pin_servo <= 0;
	   end else begin
	       stepCounter <= 0;
	   end
    end
   
endmodule
