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
    input BTNC,
    input [15:0] SW,
    output pin_XSpeed,
    output pin_XDir,
    output pin_YSpeed,
    output pin_YDir,
    output pin_servo,
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
		
	wire [31:0] xSpeed, xDirection, ySpeed, yDirection, servoReg;
		
	//call stepper.v for controlling x, y stepping with designated speed/direction
	//we call our x / y steppers if either buttons indicate or MIPS writes to those registers (and SW is high)
    wire moveL, moveR, moveU, moveD, moveServo;
    assign moveL = (xSpeed != 32'd0 && xDirection == 32'd1) ? 1'b1 : 1'b0;
    assign moveR = (xSpeed != 32'd0 && xDirection == 32'd0) ? 1'b1 : 1'b0;
    assign moveU = (ySpeed != 32'd0 && yDirection == 32'd1) ? 1'b1 : 1'b0;
    assign moveD = (ySpeed != 32'd0 && yDirection == 32'd0) ? 1'b1 : 1'b0;
    assign moveServo = (servoReg != 32'b0) ? 1'b1 : 1'b0;
    
    //if we moveL, -1 in xPositionReg; moveR, +1 in xPosReg
    //if we moveU, -1 in yPositionReg; moveD, +1 in yPosReg
    reg [31:0] x_pos, y_pos;

    always @(posedge clock) begin
        if (BTNC || reset) begin
            x_pos <= 0;
            y_pos <= 0;
        end
        if (moveL) begin
            x_pos <= x_pos - 1;
        end
        if (moveR) begin
            x_pos <= x_pos + 1;
        end
        if (moveU) begin
            y_pos <= y_pos - 1;
        end
        if (moveD) begin
            y_pos <= y_pos + 1;
        end
    end     
    
    wire [31:0] curX, curY;
    assign curX = x_pos;
    assign curY = y_pos;
    
    assign LED[0] = moveL;
    assign LED[1] = moveR;
    assign LED[2] = moveU;
    assign LED[3] = moveD;
    assign LED[15] = moveServo;
    assign LED[14:4] = 11'b0;

//    stepper_2 driveMotor(.clock(CLK100MHZ), .btn_LEFT(BTNL), .btn_RIGHT(BTNR), .btn_UP(BTNU), .btn_DOWN(BTND), .xSpeed(pin_XSpeed), .xDir(pin_XDir), .ySpeed(pin_YSpeed), .yDir(pin_YDir));
    stepper_2 driveMotor(.clock(clock), .btn_LEFT(moveL), .btn_RIGHT(moveR), .btn_UP(moveU), .btn_DOWN(moveD), .xSpeed(pin_XSpeed), .xDir(pin_XDir), .ySpeed(pin_YSpeed), .yDir(pin_YDir));

    //servo control with PWM Serializer to raise / lower pen
    //input is SW[15], leftmost switch where down means pen lowered, up means pen raised
    //SW[15] is stored in reg6, read out from reg15 
    //JA[7], pin_servo is our FPGA output signal pin
    //in MIPS, we simply need to set $r15 != 0, which triggers loop to raise pen
    servo penControl(.clock(clock), .servoControl(servoReg), .servoPWM(pin_servo));

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
		.btn_UP(BTNU), .btn_DOWN(BTND), .btn_LEFT(BTNL), .btn_RIGHT(BTNR), .btn_CENTER(BTNC),
		.switch(SW),
		.ySpeed(ySpeed), .yDirection(yDirection), .xSpeed(xSpeed), .xDirection(xDirection),
		.currentX(curX), .currentY(curY),
		.servo(servoReg));
						
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

