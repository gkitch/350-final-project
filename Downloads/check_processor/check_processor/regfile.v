module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB,
	btn_UP, btn_DOWN, btn_LEFT, btn_RIGHT,
	switch,
	ySpeed, yDirection, xSpeed, xDirection
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	
	output [31:0] data_readRegA, data_readRegB;
	
	input btn_UP, btn_DOWN, btn_LEFT, btn_RIGHT;
	input [15:0] switch;
	output [31:0] ySpeed, yDirection, xSpeed, xDirection;
	
	wire en_reg1, en_reg2, en_reg3, en_reg4;
	wire [31:0] data_reg1, data_reg2, data_reg3, data_reg4;
	assign en_reg1 = (switch[0] == 1'b1) ? reg1enable : 1'b1;
	assign en_reg2 = (switch[0] == 1'b1) ? reg2enable : 1'b1;
	assign en_reg3 = (switch[0] == 1'b1) ? reg3enable : 1'b1;
	assign en_reg4 = (switch[0] == 1'b1) ? reg4enable : 1'b1;
	assign data_reg1 = (switch[0] == 1'b1) ? data_writeReg : {31'b0, btn_UP};
	assign data_reg2 = (switch[0] == 1'b1) ? data_writeReg : {31'b0, btn_DOWN};
	assign data_reg3 = (switch[0] == 1'b1) ? data_writeReg : {31'b0, btn_LEFT};
	assign data_reg4 = (switch[0] == 1'b1) ? data_writeReg : {31'b0, btn_RIGHT};
	
	assign ySpeed = reg11out;
	assign yDirection = reg12out;
	assign xSpeed = reg13out;
	assign xDirection = reg13out;

	wire[31:0] reg0out, reg1out, reg2out, reg3out, reg4out, reg5out, reg6out, reg7out, reg8out, reg9out, reg10out, reg11out, reg12out, reg13out, reg14out, reg15out, reg16out, reg17out, reg18out, reg19out, reg20out, reg21out, reg22out, reg23out, reg24out, reg25out, reg26out, reg27out, reg28out, reg29out, reg30out, reg31out;

	wire reg0enable, reg1enable, reg2enable, reg3enable, reg4enable, reg5enable, reg6enable, reg7enable, reg8enable, reg9enable, reg10enable, reg11enable, reg12enable, reg13enable, reg14enable, reg15enable, reg16enable, reg17enable, reg18enable, reg19enable, reg20enable, reg21enable, reg22enable, reg23enable, reg24enable, reg25enable, reg26enable, reg27enable, reg28enable, reg29enable, reg30enable, reg31enable;

	wire [31:0] writeEnableDecoder = 1'b1 << ctrl_writeReg;

	//and And0(reg0enable, writeEnableDecoder[0], ctrl_writeEnable);
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
	register reg0(reg0out, reg0enable, clock, data_writeReg, ctrl_reset);
	register reg1(reg1out, en_reg1, clock, data_reg1, ctrl_reset);         //BTNU pressed --> reg1 = 1 (if SW[1] then don't override)
	register reg2(reg2out, en_reg2, clock, data_reg2, ctrl_reset);         //BTND pressed --> reg2 = 1
	register reg3(reg3out, en_reg3, clock, data_reg3, ctrl_reset);         //BTNL pressed --> reg3 = 1
	register reg4(reg4out, en_reg4, clock, data_reg4, ctrl_reset);         //BTNR pressed --> reg4 = 1
	register reg5(reg5out, reg5enable, clock, data_writeReg, ctrl_reset);
	register reg6(reg6out, reg6enable, clock, data_writeReg, ctrl_reset);
	register reg7(reg7out, reg7enable, clock, data_writeReg, ctrl_reset);
	register reg8(reg8out, reg8enable, clock, data_writeReg, ctrl_reset);
	register reg9(reg9out, reg9enable, clock, data_writeReg, ctrl_reset);
	register reg10(reg10out, reg10enable, clock, data_writeReg, ctrl_reset);
	register reg11(reg11out, reg11enable, clock, data_writeReg, ctrl_reset);
	register reg12(reg12out, reg12enable, clock, data_writeReg, ctrl_reset);
	register reg13(reg13out, reg13enable, clock, data_writeReg, ctrl_reset);
	register reg14(reg14out, reg14enable, clock, data_writeReg, ctrl_reset);
	register reg15(reg15out, reg15enable, clock, data_writeReg, ctrl_reset);
	register reg16(reg16out, reg16enable, clock, data_writeReg, ctrl_reset);
	register reg17(reg17out, reg17enable, clock, data_writeReg, ctrl_reset);
	register reg18(reg18out, reg18enable, clock, data_writeReg, ctrl_reset);
	register reg19(reg19out, reg19enable, clock, data_writeReg, ctrl_reset);
	register reg20(reg20out, reg20enable, clock, data_writeReg, ctrl_reset);
	register reg21(reg21out, reg21enable, clock, data_writeReg, ctrl_reset);
	register reg22(reg22out, reg22enable, clock, data_writeReg, ctrl_reset);
	register reg23(reg23out, reg23enable, clock, data_writeReg, ctrl_reset);
	register reg24(reg24out, reg24enable, clock, data_writeReg, ctrl_reset);
	register reg25(reg25out, reg25enable, clock, data_writeReg, ctrl_reset);
	register reg26(reg26out, reg26enable, clock, data_writeReg, ctrl_reset);
	register reg27(reg27out, reg27enable, clock, data_writeReg, ctrl_reset);
	register reg28(reg28out, reg28enable, clock, data_writeReg, ctrl_reset);
	register reg29(reg29out, reg29enable, clock, data_writeReg, ctrl_reset);
	register reg30(reg30out, reg30enable, clock, data_writeReg, ctrl_reset);
	register reg31(reg31out, reg31enable, clock, data_writeReg, ctrl_reset);

	wire[31:0] regAdecode;
	assign regAdecode = 1'b1 << ctrl_readRegA;

	tribuf triA0(reg0out, regAdecode[0], data_readRegA);
	tribuf triA1(reg1out, regAdecode[1], data_readRegA);
	tribuf triA2(reg2out, regAdecode[2], data_readRegA);
	tribuf triA3(reg3out, regAdecode[3], data_readRegA);
	tribuf triA4(reg4out, regAdecode[4], data_readRegA);
	tribuf triA5(reg5out, regAdecode[5], data_readRegA);
	tribuf triA6(reg6out, regAdecode[6], data_readRegA);
	tribuf triA7(reg7out, regAdecode[7], data_readRegA);
	tribuf triA8(reg8out, regAdecode[8], data_readRegA);
	tribuf triA9(reg9out, regAdecode[9], data_readRegA);
	tribuf triA10(reg10out, regAdecode[10], data_readRegA);
	tribuf triA11(reg11out, regAdecode[11], data_readRegA);
	tribuf triA12(reg12out, regAdecode[12], data_readRegA);
	tribuf triA13(reg13out, regAdecode[13], data_readRegA);
	tribuf triA14(reg14out, regAdecode[14], data_readRegA);
	tribuf triA15(reg15out, regAdecode[15], data_readRegA);
	tribuf triA16(reg16out, regAdecode[16], data_readRegA);
	tribuf triA17(reg17out, regAdecode[17], data_readRegA);
	tribuf triA18(reg18out, regAdecode[18], data_readRegA);
	tribuf triA19(reg19out, regAdecode[19], data_readRegA);
	tribuf triA20(reg20out, regAdecode[20], data_readRegA);
	tribuf triA21(reg21out, regAdecode[21], data_readRegA);
	tribuf triA22(reg22out, regAdecode[22], data_readRegA);
	tribuf triA23(reg23out, regAdecode[23], data_readRegA);
	tribuf triA24(reg24out, regAdecode[24], data_readRegA);
	tribuf triA25(reg25out, regAdecode[25], data_readRegA);
	tribuf triA26(reg26out, regAdecode[26], data_readRegA);
	tribuf triA27(reg27out, regAdecode[27], data_readRegA);
	tribuf triA28(reg28out, regAdecode[28], data_readRegA);
	tribuf triA29(reg29out, regAdecode[29], data_readRegA);
	tribuf triA30(reg30out, regAdecode[30], data_readRegA);
	tribuf triA31(reg31out, regAdecode[31], data_readRegA);

	wire[31:0] regBdecode;
	assign regBdecode = 1'b1 << ctrl_readRegB;

	tribuf triB0(reg0out, regBdecode[0], data_readRegB);
	tribuf triB1(reg1out, regBdecode[1], data_readRegB);
	tribuf triB2(reg2out, regBdecode[2], data_readRegB);
	tribuf triB3(reg3out, regBdecode[3], data_readRegB);
	tribuf triB4(reg4out, regBdecode[4], data_readRegB);
	tribuf triB5(reg5out, regBdecode[5], data_readRegB);
	tribuf triB6(reg6out, regBdecode[6], data_readRegB);
	tribuf triB7(reg7out, regBdecode[7], data_readRegB);
	tribuf triB8(reg8out, regBdecode[8], data_readRegB);
	tribuf triB9(reg9out, regBdecode[9], data_readRegB);
	tribuf triB10(reg10out, regBdecode[10], data_readRegB);
	tribuf triB11(reg11out, regBdecode[11], data_readRegB);
	tribuf triB12(reg12out, regBdecode[12], data_readRegB);
	tribuf triB13(reg13out, regBdecode[13], data_readRegB);
	tribuf triB14(reg14out, regBdecode[14], data_readRegB);
	tribuf triB15(reg15out, regBdecode[15], data_readRegB);
	tribuf triB16(reg16out, regBdecode[16], data_readRegB);
	tribuf triB17(reg17out, regBdecode[17], data_readRegB);
	tribuf triB18(reg18out, regBdecode[18], data_readRegB);
	tribuf triB19(reg19out, regBdecode[19], data_readRegB);
	tribuf triB20(reg20out, regBdecode[20], data_readRegB);
	tribuf triB21(reg21out, regBdecode[21], data_readRegB);
	tribuf triB22(reg22out, regBdecode[22], data_readRegB);
	tribuf triB23(reg23out, regBdecode[23], data_readRegB);
	tribuf triB24(reg24out, regBdecode[24], data_readRegB);
	tribuf triB25(reg25out, regBdecode[25], data_readRegB);
	tribuf triB26(reg26out, regBdecode[26], data_readRegB);
	tribuf triB27(reg27out, regBdecode[27], data_readRegB);
	tribuf triB28(reg28out, regBdecode[28], data_readRegB);
	tribuf triB29(reg29out, regBdecode[29], data_readRegB);
	tribuf triB30(reg30out, regBdecode[30], data_readRegB);
	tribuf triB31(reg31out, regBdecode[31], data_readRegB);

endmodule