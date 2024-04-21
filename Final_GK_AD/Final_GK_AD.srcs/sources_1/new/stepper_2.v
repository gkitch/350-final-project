`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2024 06:44:23 PM
// Design Name: 
// Module Name: stepper_2
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


module stepper_2(
    input clock,
    input btn_LEFT,
    input btn_RIGHT,
    input btn_UP,
    input btn_DOWN,
    output xSpeed,
    output xDir,
    output ySpeed,
    output yDir
    );
    
    wire clk;
    assign clk = clock;
    
    wire enX, enY;
    assign enX = (btn_LEFT || btn_RIGHT) ? 1'b1 : 1'b0;
    assign enY = (btn_UP || btn_DOWN) ? 1'b1 : 1'b0;
    
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
    
    assign xSpeed = enX ? clk1MHz : 1'b0;
    assign ySpeed = enY ? clk1MHz : 1'b0;
    
    //for direction, set 1'b1 for forwards, 1'b0 for backwards
    reg xDirection, yDirection;
    always @(posedge clk) begin
        if (btn_LEFT == 1)
            xDirection <= 1'b1;
        else begin
            xDirection <= 1'b0;
        end    
    end
    assign xDir = xDirection;

    always @(posedge clk) begin
        if (btn_UP == 1)
            yDirection <= 1'b1;
        else begin
            yDirection <= 1'b0;
        end    
    end
    assign yDir = yDirection;
    
endmodule
