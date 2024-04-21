module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB,
	btn_UP, btn_DOWN, btn_LEFT, btn_RIGHT, btn_CENTER,
	switch,
	ySpeed, yDirection, xSpeed, xDirection
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	
	output [31:0] data_readRegA, data_readRegB;
	
	input btn_UP, btn_DOWN, btn_LEFT, btn_RIGHT, btn_CENTER;
	input [15:0] switch;
	output [31:0] ySpeed, yDirection, xSpeed, xDirection;
	
	assign ySpeed = reg11out;
	assign yDirection = reg12out;
	assign xSpeed = reg13out;
	assign xDirection = reg14out;

	wire[31:0] reg0out, reg1out, reg2out, reg3out, reg4out, reg5out, reg6out, reg7out, reg8out, reg9out, reg10out, reg11out, reg12out, reg13out, reg14out, reg15out, reg16out, reg17out, reg18out, reg19out, reg20out, reg21out, reg22out, reg23out, reg24out, reg25out, reg26out, reg27out, reg28out, reg29out, reg30out, reg31out;

	wire reg0enable, reg1enable, reg2enable, reg3enable, reg4enable, reg5enable, reg6enable, reg7enable, reg8enable, reg9enable, reg10enable, reg11enable, reg12enable, reg13enable, reg14enable, reg15enable, reg16enable, reg17enable, reg18enable, reg19enable, reg20enable, reg21enable, reg22enable, reg23enable, reg24enable, reg25enable, reg26enable, reg27enable, reg28enable, reg29enable, reg30enable, reg31enable;

	wire [31:0] writeEnableDecoder = 1'b1 << ctrl_writeReg;

	//and And0(reg0enable, writeEnableDecoder[0], ctrl_writeEnable);
	assign reg0enable = 1'b0;
	and And1(reg1enable, writeEnableDecoder[1], ctrl_writeEnable);
	and And2(reg2enable, writeEnableDecoder[2], ctrl_writeEnable);
	and And3(reg3enable, writeEnableDecoder[3], ctrl_writeEnable);
	and And4(reg4enable, writeEnableDecoder[4], ctrl_writeEnable);
	and And5(reg5enable, writeEnableDecoder[5], ctrl_writeEnable);
	and And6(reg6enable, writeEnableDecoder[6], ctrl_writeEnable);
	and And7(reg7enable, writeEnableDecoder[7], ctrl_writeEnable);
	and And8(reg8enable, writeEnableDecoder[8], ctrl_writeEnable);
	and And9(reg9enable, writeEnableDecoder[9], ctrl_writeEnable);
	and And10(reg10enable, writeEnableDecoder[10], ctrl_writeEnable);
	and And11(reg11enable, writeEnableDecoder[11], ctrl_writeEnable);
	and And12(reg12enable, writeEnableDecoder[12], ctrl_writeEnable);
	and And13(reg13enable, writeEnableDecoder[13], ctrl_writeEnable);
	and And14(reg14enable, writeEnableDecoder[14], ctrl_writeEnable);
	and And15(reg15enable, writeEnableDecoder[15], ctrl_writeEnable);
	and And16(reg16enable, writeEnableDecoder[16], ctrl_writeEnable);
	and And17(reg17enable, writeEnableDecoder[17], ctrl_writeEnable);
	and And18(reg18enable, writeEnableDecoder[18], ctrl_writeEnable);
	and And19(reg19enable, writeEnableDecoder[19], ctrl_writeEnable);
	and And20(reg20enable, writeEnableDecoder[20], ctrl_writeEnable);
	and And21(reg21enable, writeEnableDecoder[21], ctrl_writeEnable);
	and And22(reg22enable, writeEnableDecoder[22], ctrl_writeEnable);
	and And23(reg23enable, writeEnableDecoder[23], ctrl_writeEnable);
	and And24(reg24enable, writeEnableDecoder[24], ctrl_writeEnable);
	and And25(reg25enable, writeEnableDecoder[25], ctrl_writeEnable);
	and And26(reg26enable, writeEnableDecoder[26], ctrl_writeEnable);
	and And27(reg27enable, writeEnableDecoder[27], ctrl_writeEnable);
	and And28(reg28enable, writeEnableDecoder[28], ctrl_writeEnable);
	and And29(reg29enable, writeEnableDecoder[29], ctrl_writeEnable);
	and And30(reg30enable, writeEnableDecoder[30], ctrl_writeEnable);
	and And31(reg31enable, writeEnableDecoder[31], ctrl_writeEnable);

	//out, input_enable, clock, in, reset
//	change to my register --> module register(readOut, clk, in_enable, writeIn, clear);

	register reg0(reg0out, clock, reg0enable, data_writeReg, ctrl_reset);
	register reg1(reg1out, clock, 1'b1, {31'b0, btn_UP}, ctrl_reset);         //BTNU pressed --> reg1 = 1 (if SW[1] then don't override)
	register reg2(reg2out, clock, 1'b1, {31'b0, btn_DOWN}, ctrl_reset);         //BTND pressed --> reg2 = 1
	register reg3(reg3out, clock, 1'b1, {31'b0, btn_LEFT}, ctrl_reset);         //BTNL pressed --> reg3 = 1
	register reg4(reg4out, clock, 1'b1, {31'b0, btn_RIGHT}, ctrl_reset);         //BTNR pressed --> reg4 = 1
	register reg5(reg5out, clock, 1'b1, {31'b0, btn_CENTER}, ctrl_reset);       //BTNC pressed --> set (0, 0) position
	register reg6(reg6out, clock, reg6enable, data_writeReg, ctrl_reset);
	register reg7(reg7out, clock, reg7enable, data_writeReg, ctrl_reset);
	register reg8(reg8out, clock, reg8enable, data_writeReg, ctrl_reset);
	register reg9(reg9out, clock, reg9enable, data_writeReg, ctrl_reset);
	register reg10(reg10out, clock, reg10enable, data_writeReg, ctrl_reset);
	register reg11(reg11out, clock, reg11enable, data_writeReg, ctrl_reset);
	register reg12(reg12out, clock, reg12enable, data_writeReg, ctrl_reset);
	register reg13(reg13out, clock, reg13enable, data_writeReg, ctrl_reset);
	register reg14(reg14out, clock, reg14enable, data_writeReg, ctrl_reset);
	register reg15(reg15out, clock, reg15enable, data_writeReg, ctrl_reset);
	register reg16(reg16out, clock, reg16enable, data_writeReg, ctrl_reset);
	register reg17(reg17out, clock, reg17enable, data_writeReg, ctrl_reset);
	register reg18(reg18out, clock, reg18enable, data_writeReg, ctrl_reset);
	register reg19(reg19out, clock, reg19enable, data_writeReg, ctrl_reset);
	register reg20(reg20out, clock, 1'b1, switch[0], ctrl_reset);                  //$r20 initializes return to origin
	register reg21(reg21out, clock, 1'b1, switch[1], ctrl_reset);                  //r21 holds value of SW[1] to toggle to demo_1
	register reg22(reg22out, clock, 1'b1, switch[2], ctrl_reset);                  //r22 toggles to demo 2
	register reg23(reg23out, clock, reg23enable, data_writeReg, ctrl_reset);
	register reg24(reg24out, clock, reg24enable, data_writeReg, ctrl_reset);
	register reg25(reg25out, clock, reg25enable, data_writeReg, ctrl_reset);
	register reg26(reg26out, clock, reg26enable, data_writeReg, ctrl_reset);
	register reg27(reg27out, clock, reg27enable, data_writeReg, ctrl_reset);
	register reg28(reg28out, clock, reg28enable, data_writeReg, ctrl_reset);
	register reg29(reg29out, clock, reg29enable, data_writeReg, ctrl_reset);
	register reg30(reg30out, clock, reg30enable, data_writeReg, ctrl_reset);
	register reg31(reg31out, clock, reg31enable, data_writeReg, ctrl_reset);

	wire[31:0] regAdecode;
	assign regAdecode = 1'b1 << ctrl_readRegA;
//change to my tristate --> module tristate(out, in, enable);
	tristate triA0(data_readRegA, reg0out, regAdecode[0]);
	tristate triA1(data_readRegA, reg1out, regAdecode[1]);
	tristate triA2(data_readRegA, reg2out, regAdecode[2]);
	tristate triA3(data_readRegA, reg3out, regAdecode[3]);
	tristate triA4(data_readRegA, reg4out, regAdecode[4]);
	tristate triA5(data_readRegA, reg5out, regAdecode[5]);
	tristate triA6(data_readRegA, reg6out, regAdecode[6]);
	tristate triA7(data_readRegA, reg7out, regAdecode[7]);
	tristate triA8(data_readRegA, reg8out, regAdecode[8]);
	tristate triA9(data_readRegA, reg9out, regAdecode[9]);
	tristate triA10(data_readRegA, reg10out, regAdecode[10]);
	tristate triA11(data_readRegA, reg11out, regAdecode[11]);
	tristate triA12(data_readRegA, reg12out, regAdecode[12]);
	tristate triA13(data_readRegA, reg13out, regAdecode[13]);
	tristate triA14(data_readRegA, reg14out, regAdecode[14]);
	tristate triA15(data_readRegA, reg15out, regAdecode[15]);
	tristate triA16(data_readRegA, reg16out, regAdecode[16]);
	tristate triA17(data_readRegA, reg17out, regAdecode[17]);
	tristate triA18(data_readRegA, reg18out, regAdecode[18]);
	tristate triA19(data_readRegA, reg19out, regAdecode[19]);
	tristate triA20(data_readRegA, reg20out, regAdecode[20]);
	tristate triA21(data_readRegA, reg21out, regAdecode[21]);
	tristate triA22(data_readRegA, reg22out, regAdecode[22]);
	tristate triA23(data_readRegA, reg23out, regAdecode[23]);
	tristate triA24(data_readRegA, reg24out, regAdecode[24]);
	tristate triA25(data_readRegA, reg25out, regAdecode[25]);
	tristate triA26(data_readRegA, reg26out, regAdecode[26]);
	tristate triA27(data_readRegA, reg27out, regAdecode[27]);
	tristate triA28(data_readRegA, reg28out, regAdecode[28]);
	tristate triA29(data_readRegA, reg29out, regAdecode[29]);
	tristate triA30(data_readRegA, reg30out, regAdecode[30]);
	tristate triA31(data_readRegA, reg31out, regAdecode[31]);

	wire[31:0] regBdecode;
	assign regBdecode = 1'b1 << ctrl_readRegB;

	tristate triB0(data_readRegB, reg0out, regBdecode[0]);
	tristate triB1(data_readRegB, reg1out, regBdecode[1]);
	tristate triB2(data_readRegB, reg2out, regBdecode[2]);
	tristate triB3(data_readRegB, reg3out, regBdecode[3]);
	tristate triB4(data_readRegB, reg4out, regBdecode[4]);
	tristate triB5(data_readRegB, reg5out, regBdecode[5]);
	tristate triB6(data_readRegB, reg6out, regBdecode[6]);
	tristate triB7(data_readRegB, reg7out, regBdecode[7]);
	tristate triB8(data_readRegB, reg8out, regBdecode[8]);
	tristate triB9(data_readRegB, reg9out, regBdecode[9]);
	tristate triB10(data_readRegB, reg10out, regBdecode[10]);
	tristate triB11(data_readRegB, reg11out, regBdecode[11]);
	tristate triB12(data_readRegB, reg12out, regBdecode[12]);
	tristate triB13(data_readRegB, reg13out, regBdecode[13]);
	tristate triB14(data_readRegB, reg14out, regBdecode[14]);
	tristate triB15(data_readRegB, reg15out, regBdecode[15]);
	tristate triB16(data_readRegB, reg16out, regBdecode[16]);
	tristate triB17(data_readRegB, reg17out, regBdecode[17]);
	tristate triB18(data_readRegB, reg18out, regBdecode[18]);
	tristate triB19(data_readRegB, reg19out, regBdecode[19]);
	tristate triB20(data_readRegB, reg20out, regBdecode[20]);
	tristate triB21(data_readRegB, reg21out, regBdecode[21]);
	tristate triB22(data_readRegB, reg22out, regBdecode[22]);
	tristate triB23(data_readRegB, reg23out, regBdecode[23]);
	tristate triB24(data_readRegB, reg24out, regBdecode[24]);
	tristate triB25(data_readRegB, reg25out, regBdecode[25]);
	tristate triB26(data_readRegB, reg26out, regBdecode[26]);
	tristate triB27(data_readRegB, reg27out, regBdecode[27]);
	tristate triB28(data_readRegB, reg28out, regBdecode[28]);
	tristate triB29(data_readRegB, reg29out, regBdecode[29]);
	tristate triB30(data_readRegB, reg30out, regBdecode[30]);
	tristate triB31(data_readRegB, reg31out, regBdecode[31]);

endmodule