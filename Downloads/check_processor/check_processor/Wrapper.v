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
    assign reset = BTNU;
    
    wire [31:0] q_dmem;

    wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;
		
	//call stepper.v for controlling x, y stepping with designated speed/direction
	//we call our x / y steppers if either buttons indicate or MIPS writes to those registers (and SW is high)
	x_stepper xMotor(.en(BTNL || BTNR), .xSpeed(xSpeed), .xDirection(xDirection), .out_xSpeed(pin_XSpeed), .out_xDirection(pin_XDir));
	x_stepper yMotor(.en(BTNU || BTND), .ySpeed(ySpeed), .yDirection(yDirection), .out_ySpeed(pin_YSpeed), .out_yDirection(pin_YDir));

	//hijack any instruction trying to write to $r1-$r4 - change it to be a button press
	wire reg1_used, reg2_used, reg3_used, reg4_used;
	//if rd = reg1-4 and rwe (basically, arithmetic with that reg)
	assign reg1_used = (rd == 32'd1 && rwe) ? 1'b1 : 1'b0;
	assign reg2_used = (rd == 32'd2 && rwe) ? 1'b1 : 1'b0;
	assign reg3_used = (rd == 32'd3 && rwe) ? 1'b1 : 1'b0;
	assign reg4_used = (rd == 32'd4 && rwe) ? 1'b1 : 1'b0;
    
    //need to modify this so it handles the code inputs only when SW[0] is high (when we use hardcoded insn)
    //otherwise, we should never have MIPS that touches $r1 - $r4
    wire btn_UP, btn_DOWN, btn_LEFT, btn_RIGHT;
    assign btn_UP = (BTNU || reg1_used) ? 1'b1 : 1'b0;
    assign btn_DOWN = (BTND || reg2_used) ? 1'b1 : 1'b0;
    assign btn_LEFT = (BTNL || reg3_used) ? 1'b1 : 1'b0;
    assign btn_RIGHT = (BTNR || reg4_used) ? 1'b1 : 1'b0;
	
	wire io_read, io_write;
	reg [15:0] SW_Q, SW_M;

	assign io_read = (memAddr == 32'd4000) ? 1'b1 : 1'b0;
	assign io_write = (memAddr == 32'd4001) ? 1'b1 : 1'b0;
	always @(negedge clock) begin
	   SW_M <= SW;
	   SW_Q <= SW_M;
	end
	reg [15:0] LED_reg;
	always @(posedge clock) begin
	   if (io_write == 1'b1) begin
	       LED_reg <= memDataIn[15:0];
	   end else begin
	       LED_reg <= LED_reg;
	   end
	end
	assign LED = LED_reg;
	
	assign q_dmem = (io_read == 1'b1) ? SW : memDataOut;
  	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "fpga_test2";
	
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

