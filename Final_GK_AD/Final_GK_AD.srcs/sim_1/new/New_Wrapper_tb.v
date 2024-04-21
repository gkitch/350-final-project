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

    reg btnu, btnd, btnl, btnr, clk;
    reg [15:0] SW;
    wire out_xSpeed, out_xDir, out_ySpeed, out_yDir;
    wire [15:0] LED;
    Wrapper wrap(.CLK100MHZ(clk), .BTNU(btnu), .BTND(btnd), .BTNL(btnl), .BTNR(btnr),
                    .SW(SW), .pin_XSpeed(out_xSpeed), .pin_XDir(out_xDir), .pin_YSpeed(out_ySpeed), .pin_YDir(out_yDir),
                    .LED(LED));
    initial begin
        btnu = 0;
        btnd = 0;
        btnl = 0;
        btnr = 0;
        clk = 0;
        SW = 15'd0;
        #100
        btnu = 1;
    end
    
    always
		#10 clk = ~clk; 

              
endmodule
