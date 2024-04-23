`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2024 01:30:16 PM
// Design Name: 
// Module Name: New_Wrapper_tb
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


module New_Wrapper_tb();

    reg btnu, btnd, btnl, btnr, btnc, clk;
    reg [15:0] SW;
    wire out_xSpeed, out_xDir, out_ySpeed, out_yDir, out_servo;
    wire [15:0] LED;
    Wrapper wrap(.CLK100MHZ(clk), .BTNU(btnu), .BTND(btnd), .BTNL(btnl), .BTNR(btnr), .BTNC(btnc),
                    .SW(SW), .pin_XSpeed(out_xSpeed), .pin_XDir(out_xDir), .pin_YSpeed(out_ySpeed), .pin_YDir(out_yDir),
                    .pin_servo(out_servo), .LED(LED));
    initial begin
        btnu = 0;
        btnd = 0;
        btnl = 0;
        btnr = 0;
        btnc = 1;
        clk = 0;
        SW = 15'd0;
        #100
        btnu = 1;
        #10
        btnc = 1;
        #10
        btnr = 1;
        #500
        btnr = 0;
        btnd = 1;
        #500
        SW[0] = 1;
        
    end
    
    always
		#10 clk = ~clk; 

              
endmodule
