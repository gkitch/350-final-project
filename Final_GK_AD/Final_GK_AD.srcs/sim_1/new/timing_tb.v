`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2024 06:45:37 PM
// Design Name: 
// Module Name: timing_tb
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


module timing_tb;


reg CLK100MHZ = 1'b0;
reg BTNU = 1'b0;
reg [15:0] SW = 16'd0;
wire [15:0] LED;

Wrapper srapper (
    .CLK100MHZ(CLK100MHZ),
    .BTNU(BTNU),
    .SW(SW),
    .LED(LED));

initial begin
    BTNU = 1'b0;
    #20;
    BTNU = 1'b1;
    #20;
    BTNU = 1'b0;
    #100;
    SW = 16'd7;
end

always begin
#10 CLK100MHZ <= ~CLK100MHZ;
end
endmodule
