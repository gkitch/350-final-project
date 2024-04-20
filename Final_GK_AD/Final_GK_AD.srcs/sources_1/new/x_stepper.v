`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2024 01:32:40 PM
// Design Name: 
// Module Name: x_stepper
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


module x_stepper(
    input CLK100MHZ,
    input en,
    input [31:0] xSpeed,
    input [31:0] xDirection,
    output out_xSpeed,
    output out_xDirection
    );
    
    wire clk;
    assign clk = CLK100MHZ;
    
    wire [17:0] stepCounterLimit;
    //modify stepCounterLimit to control speed
    //  fastest = 49999, slowest = 124999 (maybe map to 1 -> 5)
	assign stepCounterLimit = 49999;
	
	reg clk1MHz = 0;
	reg [17:0] stepCounter = 0;
	always @(posedge clk) begin
	   if (stepCounter < stepCounterLimit)
	       stepCounter <= stepCounter + 1;
	   else begin
	       stepCounter <= 0;
	       clk1MHz <= ~ clk1MHz;
	   end
    end
    
    assign out_xSpeed = (en && clk1MHz) ? clk1MHz : 1'b0;
    
    //for direction, set 1'b1 for forwards, 1'b0 for backwards
    assign out_xDirection = xDirection[0];
    
endmodule
