`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// ECEN-651 microprogrammed control of Digital systems
// Lab	       : Lab5
// File name   : SingleCycleProc.v
// Created by  : Sai Manish Gopu
// UIN         : 334003269
// Design      : Designing a Non-pipelined  Single Cycle Processor
// Not for external use other than Texas A&M University
//////////////////////////////////////////////////////////////////////////

module SingleCycleProc(CLK, Reset_L, startPC, dMemOut);

input CLK;
input Reset_L;
input [31:0] startPC;
output [31:0] dMemOut;

wire [31:0] instruction;
wire [31:0] jump_address;
wire zero;
wire and_in;
wire RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump, SignExtend;
wire [31:0] sign_extend;
wire [31:0] branch;
wire [3:0] ALUOp;
wire [31:0] mux0;
wire [31:0] mux1;
wire [31:0] mux2;
wire [31:0] mux3;
wire [4:0] mux4;
wire [31:0] alu_input1;
wire [31:0] alu_input2;
wire [31:0] alu_result;
wire [3:0] aluctrl;
reg [31:0] program_counter;
wire [31:0] next_program_counter;
wire [31:0] immediate_shift;

//Instantiation of DataMemory
DataMemory DataMemory(.Address(alu_result[5:0]),.WriteData(alu_input2),.MemoryRead(MemRead),.MemoryWrite(MemWrite),.Clock(CLK),.ReadData(dMemOut));

//Instantiation of RegisterFile
RegisterFile RegisterFile(.BusW(mux1),.RA(instruction[25:21]),.RB(instruction[20:16]),.RW(mux4),.RegWr(RegWrite),.Clk(CLK),.BusA(alu_input1),.BusB(alu_input2));

//Instantiation of ALU
ALU ALU(.BusW(alu_result), .Zero(zero), .BusA(alu_input1), .BusB(mux0),.ALUCtrl(aluctrl));

//Instantiation of ALU_Control
ALU_Control ALU_Control(.ALUCtrl(aluctrl), .ALUop(ALUOp), .FuncCode(instruction[5:0]));

//Instantiation of SingleCycleControl
SingleCycleControl SingleCycleControl(.RegDst(RegDst), .ALUSrc(ALUSrc), .MemToReg(MemToReg), .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite), 
                                      .Branch(Branch), .Jump(Jump), .SignExtend(SignExtend), .ALUOp(ALUOp), .Opcode(instruction[31:26]));

//Instantiation of InstructionMemory
InstructionMemory InstructionMemory(.Data(instruction), .Address(program_counter));

//Logic
always @(negedge(CLK) or negedge(Reset_L))
if(Reset_L==0)
    program_counter <=startPC;
else
    program_counter <=mux3;

//Next Program Counter
assign next_program_counter = program_counter+4;
   
//Sign Extension
assign sign_extend[15:0]=instruction[15:0];
assign sign_extend[31:16]= SignExtend ? {16{sign_extend[15]}} : {16{1'b0}};

//Immediate Shift
assign immediate_shift = sign_extend << 2;

//Branching
assign branch=next_program_counter+immediate_shift;
assign and_in=Branch&zero;

//Jump Instruction
assign jump_address= {next_program_counter[31:28],instruction[25:0],2'b00};

//Defining MUXes
assign mux0 = ALUSrc ? sign_extend : alu_input2 ;
assign mux1 = MemToReg ? dMemOut : alu_result ;
assign mux2 = and_in ? branch : next_program_counter;
assign mux3 = Jump ? jump_address : mux2;
assign mux4 = RegDst ? instruction[15:11] : instruction[20:16];

endmodule
