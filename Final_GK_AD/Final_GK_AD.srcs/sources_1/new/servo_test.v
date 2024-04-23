`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2024 07:54:24 PM
// Design Name: 
// Module Name: servo_test
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


module servo_test(
    input CLK100MHZ,
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
    output pin_servo,
    output [15:0] LED
    );
        
    wire clock, reset;
    assign clock = CLK100MHZ;
    assign reset = 1'b0;
        
    PWMSerializer servo_test(.clk(clock), .reset(reset), .regIn({31'b0, BTNU}), .signal(pin_servo));
    
    assign pin_XDir = 0;
    assign pin_YDir = 0;
    assign pin_XSpeed = 0;
    assign pin_YSpeed = 0;
    assign LED =  16'b0;
    
endmodule
