// /**
//  * READ THIS DESCRIPTION!
//  *
//  * This is your processor module that will contain the bulk of your code submission. You are to implement
//  * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
//  * necessary.
//  *
//  * Ultimately, your processor will be tested by a master skeleton, so the
//  * testbench can see which controls signal you active when. Therefore, there needs to be a way to
//  * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
//  * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
//  * for more details.
//  *
//  * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
//  * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
//  * in your Wrapper module. This is the same for your memory elements. 
//  *
//  *
//  */
// module simple_processor(
//     // Control signals
//     clock,                          // I: The master clock
//     reset,                          // I: A reset signal

//     // Imem
//     address_imem,                   // O: The address of the data to get from imem
//     q_imem,                         // I: The data from imem

//     // Dmem
//     address_dmem,                   // O: The address of the data to get or put from/to dmem
//     data,                           // O: The data to write to dmem
//     wren,                           // O: Write enable for dmem
//     q_dmem,                         // I: The data from dmem

//     // Regfile
//     ctrl_writeEnable,               // O: Write enable for RegFile
//     ctrl_writeReg,                  // O: Register to write to in RegFile
//     ctrl_readRegA,                  // O: Register to read from port A of RegFile
//     ctrl_readRegB,                  // O: Register to read from port B of RegFile
//     data_writeReg,                  // O: Data to write to for RegFile
//     data_readRegA,                  // I: Data from port A of RegFile
//     data_readRegB                   // I: Data from port B of RegFile
	 
// 	);

// 	// Control signals
// 	input clock, reset;
	
// 	// Imem
//     output [31:0] address_imem;
// 	input [31:0] q_imem;

// 	// Dmem
// 	output [31:0] address_dmem, data;
// 	output wren;
// 	input [31:0] q_dmem;

// 	// Regfile
// 	output ctrl_writeEnable;
// 	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
// 	output [31:0] data_writeReg;
// 	input [31:0] data_readRegA, data_readRegB;

// 	/* YOUR CODE STARTS HERE */

//     // ******* FETCH *******
//     wire [31:0] pc_in, pc_out;
//     wire pc_ovf;
//     cl_adder next_pc(.data_A(pc_out), .data_B(32'b0), .Cin(1'b1), .out(pc_in), .overflow(pc_ovf));
//     register pc_reg(.readOut(pc_out), .clk(~clock), .in_enable(1'b1), .writeIn(pc_in), .clear(reset));

//     assign address_imem = pc_out;
//     // now, q_imem is our instruction

//     // F/D Latch
//     wire [31:0] fd_data_A, fd_data_B, fd_insn, fd_pc;
//     latch fd(.pc(address_imem), .instruction(q_imem), .clk(~clock), .reset(reset), .data_A(32'b0), .data_B(32'b0),
//                 .pcOut(fd_pc), .insnOut(fd_insn), .data_A_out(fd_data_A), .data_B_out(fd_data_B));

//     // ******* DECODE *******
//     // r type wires
//     wire [5:0] rs, rt;
//     assign rs = fd_insn[21:17];
//     assign rt = fd_insn[16:12];
//     // get values from register
//     assign ctrl_readRegA = rs;
//     assign ctrl_readRegB = rt;
//     // now, data_readRegA/B automatically stores values

//     // D/X Latch
//     wire [31:0] dx_data_A, dx_data_B, dx_insn, dx_pc;
//     latch dx(.pc(fd_pc), .instruction(fd_insn), .clk(~clock), .reset(reset), .data_A(data_readRegA), .data_B(data_readRegB),
//                 .pcOut(dx_pc), .insnOut(dx_insn), .data_A_out(dx_data_A), .data_B_out(dx_data_B));

//     // ****** EXECUTE *******
//     // opcode
//     wire [4:0] opcode;
//     assign opcode = dx_insn[31:27];
//     // r type wires
//     wire [4:0] shamt, r_type_aluOp, aluOp;
//     // i type wires
//     wire [16:0] immed;
//     wire [31:0] extendedImmed;
//     // assign values from instructions
//     assign shamt = dx_insn[11:7];
//     assign r_type_aluOp = dx_insn[6:2];
//     assign immed = dx_insn[16:0];
//     sign_extend extendImmed(.data(immed), .out(extendedImmed));
//     // pick between (sign-extended) immediate and B for second ALU input
//     wire useImmed;
//     wire [31:0] intoALU_B, alu_out, multdiv_out;
//     assign useImmed = (opcode == 5'b00000) ? 1'b0 : 1'b1;
//     assign intoALU_B = useImmed ? extendedImmed : dx_data_B;
//     assign aluOp = useImmed ? 5'b00000 : r_type_aluOp;
//     // run separate calculation for mult/div
//     // if it is a mult/div op, we need to delay until it is complete
//     // if mult/div AND not data_resultRDY --> delay is true
//     // our opcode can be our ctrl_MULT/ctrl_DIV
//     // multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);
//     // if aluOp is 00110 (mult) or 00101 (div)
//     // multdiv mymultdiv(.data_operandA(dx_data_A), .data_operandB(intoALU_B), .ctrl_MULT(), .ctrl_DIV(),
//     //                     .clock(), .data_result(), .data_exception(), .data_resultRDY());

//     //TODO
//     // branching
//     // if we end up branching (alu comparison), flush out D, E stage instructions, and set PC to proper val
//     // jumping
//     // set next PC to proper value, and flush - link $31 if JAL

//     // call our ALU
//     wire isNotEqual, isLessThan, alu_ovf;
//     alu myALU(.data_operandA(dx_data_A), .data_operandB(intoALU_B), .ctrl_ALUopcode(aluOp), .ctrl_shiftamt(shamt),
//                 .data_result(alu_out), .isNotEqual(isNotEqual), .isLessThan(isLessThan), .overflow(alu_ovf));
//     // pick between multdiv output and alu_out (if 00110 or 00101 --> multdiv)
//     // this value gets passed into "A" of next latch
//     wire [31:0] x_out;
//     // assign x_out = (aluOp == 5'b00101 || aluOp == 5'b00110) ? multdiv_out : alu_out;
//     assign x_out = alu_out;

//     // ****************
//     // *** xm latch ***
//     wire [31:0] xm_data_A, xm_data_B, xm_insn, xm_pc;
//     latch xm(.pc(dx_pc), .instruction(dx_insn), .clk(~clock), .reset(reset), .data_A(x_out), .data_B(dx_data_B),
//                 .pcOut(xm_pc), .insnOut(xm_insn), .data_A_out(xm_data_A), .data_B_out(xm_data_B));

//     // ********************
//     // ****** MEMORY ******
//     // writing things to memory / loading from memory

//     // ********************
//     // ***** mw latch *****
//     wire [31:0] mw_data_A, mw_data_B, mw_insn, mw_pc;
//     latch mw(.pc(xm_pc), .instruction(xm_insn), .clk(~clock), .reset(reset), .data_A(xm_data_A), .data_B(xm_data_B),
//                 .pcOut(mw_pc), .insnOut(mw_insn), .data_A_out(mw_data_A), .data_B_out(mw_data_B));

//     // *********************
//     // ***** WRITEBACK *****
//     // do we need to writeback to the register to update the value?
//     // write our resulting value (dataA) to rd (insn[26:22])
//     assign ctrl_writeEnable = 1'b1;
//     assign ctrl_writeReg = mw_insn[26:22];
//     assign data_writeReg = mw_data_A;

// 	/* END CODE */

// endmodule
