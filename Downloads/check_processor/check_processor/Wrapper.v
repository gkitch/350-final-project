`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (
    input CLK100MHZ,
    input BTNU,
    input BTND,
    input BTNR,
    input BTNL,
    input [15:0] SW,
    output pin_XSpeed,
    output pin_XDir,
    output pin_YSpeed,
    output pin_YDir,
    output [15:0] LED);
    
    wire clock, reset;
    assign clock = CLK100MHZ;
    assign reset = 1'b0;
    
    wire [31:0] q_dmem;

    wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;
		
	wire [31:0] xSpeed, xDirection, ySpeed, yDirection;
		
	//call stepper.v for controlling x, y stepping with designated speed/direction
	//we call our x / y steppers if either buttons indicate or MIPS writes to those registers (and SW is high)
    wire moveL, moveR, moveU, moveD;
    assign moveL = (xSpeed != 32'd0 && xDirection == 32'd1) ? 1'b1 : 1'b0;
    assign moveR = (xSpeed != 32'd0 && xDirection == 32'd0) ? 1'b1 : 1'b0;
    assign moveU = (ySpeed != 32'd0 && yDirection == 32'd1) ? 1'b1 : 1'b0;
    assign moveD = (ySpeed != 32'd0 && yDirection == 32'd0) ? 1'b1 : 1'b0;
    
    assign LED[0] = moveL;
    assign LED[1] = moveR;
    assign LED[2] = moveU;
    assign LED[3] = moveD;
    assign LED[15:4] = 12'b0;

//    stepper_2 driveMotor(.clock(CLK100MHZ), .btn_LEFT(BTNL), .btn_RIGHT(BTNR), .btn_UP(BTNU), .btn_DOWN(BTND), .xSpeed(pin_XSpeed), .xDir(pin_XDir), .ySpeed(pin_YSpeed), .yDir(pin_YDir));
    stepper_2 driveMotor(.clock(CLK100MHZ), .btn_LEFT(moveL), .btn_RIGHT(moveR), .btn_UP(moveU), .btn_DOWN(moveD), .xSpeed(pin_XSpeed), .xDir(pin_XDir), .ySpeed(pin_YSpeed), .yDir(pin_YDir));

	
  	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "example_master";
	
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(q_dmem)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
		//added values to be accessed / hardwired to (r1-r4 are buttons, r11-r14 are outputs for speed/direction)
		.btn_UP(BTNU), .btn_DOWN(BTND), .btn_LEFT(BTNL), .btn_RIGHT(BTNR),
		.switch(SW),
		.ySpeed(ySpeed), .yDirection(yDirection), .xSpeed(xSpeed), .xDirection(xDirection));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

endmodule



//`timescale 1ns / 1ps
///**
// * 
// * READ THIS DESCRIPTION:
// *
// * This is the Wrapper module that will serve as the header file combining your processor, 
// * RegFile and Memory elements together.
// *
// * This file will be used to generate the bitstream to upload to the FPGA.
// * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
// * 
// * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
// * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
// * provided Wrapper interface.
// * 
// * Refer to Lab 5 documents for detailed instructions on how to interface 
// * with the memory elements. Each imem and dmem modules will take 12-bit 
// * addresses and will allow for storing of 32-bit values at each address. 
// * Each memory module should receive a single clock. At which edges, is 
// * purely a design choice (and thereby up to you). 
// * 
// * You must change line 36 to add the memory file of the test you created using the assembler
// * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
// *
// **/

//module Wrapper (
//    input CLK100MHZ,
//    input BTNU,
//    input [15:0] SW,
//    output [15:0] LED);
    
//    wire clock, reset;
//    assign clock = CLK100MHZ;
//    assign reset = BTNU;
    
//    wire [31:0] q_dmem;

//    wire rwe, mwe;
//	wire[4:0] rd, rs1, rs2;
//	wire[31:0] instAddr, instData, 
//		rData, regA, regB,
//		memAddr, memDataIn, memDataOut;
	
//	wire io_read, io_write;
//	reg [15:0] SW_Q, SW_M;

//	assign io_read = (memAddr == 32'd4000) ? 1'b1 : 1'b0;
//	assign io_write = (memAddr == 32'd4001) ? 1'b1 : 1'b0;
//	always @(negedge clock) begin
//	   SW_M <= SW;
//	   SW_Q <= SW_M;
//	end
//	reg [15:0] LED_reg;
//	always @(posedge clock) begin
//	   if (io_write == 1'b1) begin
//	       LED_reg <= memDataIn[15:0];
//	   end else begin
//	       LED_reg <= LED_reg;
//	   end
//	end
//	assign LED = LED_reg;
	
//	assign q_dmem = (io_read == 1'b1) ? SW : memDataOut;
////    assign q_dmem = SW;
//  	// ADD YOUR MEMORY FILE HERE
//	localparam INSTR_FILE = "fpga_test2";
	
//	// Main Processing Unit
//	processor CPU(.clock(clock), .reset(reset), 
								
//		// ROM
//		.address_imem(instAddr), .q_imem(instData),
									
//		// Regfile
//		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
//		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
//		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
//		// RAM
//		.wren(mwe), .address_dmem(memAddr), 
//		.data(memDataIn), .q_dmem(q_dmem)); 
	
//	// Instruction Memory (ROM)
//	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
//	InstMem(.clk(clock), 
//		.addr(instAddr[11:0]), 
//		.dataOut(instData));
	
//	// Register File
//	regfile RegisterFile(.clock(clock), 
//		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
//		.ctrl_writeReg(rd),
//		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
//		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB));
						
//	// Processor Memory (RAM)
//	RAM ProcMem(.clk(clock), 
//		.wEn(mwe), 
//		.addr(memAddr[11:0]), 
//		.dataIn(memDataIn), 
//		.dataOut(memDataOut));

//endmodule

