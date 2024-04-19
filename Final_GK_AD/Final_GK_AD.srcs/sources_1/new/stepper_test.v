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
    input BTNL,
    input BTNR,
    input BTNU,
    input BTND,
    output pin_XSpeed,
    output pin_XDir,
    output pin_YSpeed,
    output pin_YDir
    );
    
    wire clk;
    assign clk = CLK100MHZ;
    
    wire enX, enY;
    assign enX = (BTNL || BTNR) ? 1'b1 : 1'b0;
    assign enY = (BTNU || BTND) ? 1'b1 : 1'b0;
    
    wire [17:0] stepCounterLimit;
    //for transition to x, y would have separate files controlling each movement
	assign stepCounterLimit = 50000;
	
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
    
    assign pin_XSpeed = enX ? clk1MHz : 1'b0;
    assign pin_YSpeed = enY ? clk1MHz : 1'b0;
    
    //for direction, set 1'b1 for forwards, 1'b0 for backwards
    reg xDirection, yDirection;
    always @(posedge clk) begin
        if (BTNL == 1)
            xDirection <= 1'b1;
        else begin
            xDirection <= 1'b0;
        end    
    end
    assign pin_XDir = xDirection;

    always @(posedge clk) begin
        if (BTNU == 1)
            yDirection <= 1'b1;
        else begin
            yDirection <= 1'b0;
        end    
    end
    assign pin_YDir = yDirection;
    
endmodule
