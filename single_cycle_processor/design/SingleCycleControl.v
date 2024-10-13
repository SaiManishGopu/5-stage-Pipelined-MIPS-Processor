`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// ECEN-651 microprogrammed control of Digital systems
// Lab	       : Lab5
// File name   : SingleCycleControl.v
// Created by  : Sai Manish Gopu
// UIN         : 334003269
// Design      : Designing a Non-pipelined  Single Cycle Processor
// Not for external use other than Texas A&M University
//////////////////////////////////////////////////////////////////////////
`define RTYPEOPCODE 6'b000000
`define LWOPCODE    6'b100011
`define SWOPCODE    6'b101011
`define BEQOPCODE   6'b000100
`define JOPCODE     6'b000010
`define ORIOPCODE   6'b001101
`define ADDIOPCODE  6'b001000
`define ADDIUOPCODE 6'b001001
`define ANDIOPCODE  6'b001100
`define LUIOPCODE   6'b001111
`define SLTIOPCODE  6'b001010
`define SLTIUOPCODE 6'b001011
`define XORIOPCODE  6'b001110

`define AND     4'b0000
`define OR      4'b0001
`define ADD     4'b0010
`define SLL     4'b0011
`define SRL     4'b0100
`define SUB     4'b0110
`define SLT     4'b0111
`define ADDU    4'b1000
`define SUBU    4'b1001
`define XOR     4'b1010
`define SLTU    4'b1011
`define NOR     4'b1100
`define SRA     4'b1101
`define LUI     4'b1110
`define FUNC    4'b1111

module SingleCycleControl(RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump, SignExtend, ALUOp, Opcode);
   input [5:0] Opcode;
   output RegDst;
   output ALUSrc;
   output MemToReg;
   output RegWrite;
   output MemRead;
   output MemWrite;
   output Branch;
   output Jump;
   output SignExtend;
   output [3:0] ALUOp;
     
    reg RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump, SignExtend;
    reg  [3:0] ALUOp;
    always @ (Opcode) begin
        case(Opcode)
            //Datapath selection for R Type Instructions
            `RTYPEOPCODE: begin
                RegDst <= #2 1;
                ALUSrc <= #2 0;
                MemToReg <= #2 0;
                RegWrite <= #2 1;
                MemRead <= #2 0;
                MemWrite <= #2 0;
                Branch <= #2 0;
                Jump <= #2 0;
                SignExtend <= #2 1'b0;
                ALUOp <= #2 `FUNC;
            end
            /*add code here*/
			
			//Datapath selection for Load Word
			`LWOPCODE: begin
                RegDst <= #2 0;
                ALUSrc <= #2 1;
                MemToReg <= #2 1;
                RegWrite <= #2 1;
                MemRead <= #2 1;
                MemWrite <= #2 0;
                Branch <= #2 0;
                Jump <= #2 0;
                SignExtend <= #2 1'b1;
                ALUOp <= #2 `ADD;
            end
			
			//Datapath selection for Store Word
			`SWOPCODE: begin
                RegDst <= #2 0;
                ALUSrc <= #2 1;
                MemToReg <= #2 0;
                RegWrite <= #2 0;
                MemRead <= #2 0;
                MemWrite <= #2 1;
                Branch <= #2 0;
                Jump <= #2 0;
                SignExtend <= #2 1'b1;
                ALUOp <= #2 `ADD;
            end
			
			//Datapath selection for Branch Instructions
			`BEQOPCODE: begin
                RegDst <= #2 0;
                ALUSrc <= #2 0;
                MemToReg <= #2 0;
                RegWrite <= #2 0;
                MemRead <= #2 0;
                MemWrite <= #2 0;
                Branch <= #2 1;
                Jump <= #2 0;
                SignExtend <= #2 1'b1;
                ALUOp <= #2 `SUB;
            end
			
			//Datapath selection for Jump Instructions
			`JOPCODE: begin
                RegDst <= #2 0;
                ALUSrc <= #2 0;
                MemToReg <= #2 0;
                RegWrite <= #2 0;
                MemRead <= #2 0;
                MemWrite <= #2 0;
                Branch <= #2 0;
                Jump <= #2 1;
                SignExtend <= #2 1'b0;
                ALUOp <= #2 `AND;
            end
			
			//Datapath selection for OR Immediate
			`ORIOPCODE: begin
                RegDst <= #2 0;
                ALUSrc <= #2 1;
                MemToReg <= #2 0;
                RegWrite <= #2 1;
                MemRead <= #2 0;
                MemWrite <= #2 0;
                Branch <= #2 0;
                Jump <= #2 0;
                SignExtend <= #2 1'b0;
                ALUOp <= #2 `OR;
            end
			
			//Datapath selection for ADD Immediate
			`ADDIOPCODE: begin
                RegDst <= #2 0;
                ALUSrc <= #2 1;
                MemToReg <= #2 0;
                RegWrite <= #2 1;
                MemRead <= #2 0;
                MemWrite <= #2 0;
                Branch <= #2 0;
                Jump <= #2 0;
                SignExtend <= #2 1'b1;
                ALUOp <= #2 `ADD;
            end
			
			//Datapath selection for Unsigned ADD Immediate
			`ADDIUOPCODE: begin
                RegDst <= #2 0;
                ALUSrc <= #2 1;
                MemToReg <= #2 0;
                RegWrite <= #2 1;
                MemRead <= #2 0;
                MemWrite <= #2 0;
                Branch <= #2 0;
                Jump <= #2 0;
                SignExtend <= #2 1'b0;
                ALUOp <= #2 `ADDU;
            end
			
			//Datapath selection for AND Immediate
			`ANDIOPCODE: begin
                RegDst <= #2 0;
                ALUSrc <= #2 1;
                MemToReg <= #2 0;
                RegWrite <= #2 1;
                MemRead <= #2 0;
                MemWrite <= #2 0;
                Branch <= #2 0;
                Jump <= #2 0;
                SignExtend <= #2 1'b0;
                ALUOp <= #2 `AND;
            end
			
			//Datapath selection for Load Upper Immediate
			`LUIOPCODE: begin
                RegDst <= #2 0;
                ALUSrc <= #2 1;
                MemToReg <= #2 0;
                RegWrite <= #2 1;
                MemRead <= #2 0;
                MemWrite <= #2 0;
                Branch <= #2 0;
                Jump <= #2 0;
                SignExtend <= #2 1'b0;
                ALUOp <= #2 `LUI;
            end
			
			//Datapath selection for Shift Left Immediate
			`SLTIOPCODE: begin
                RegDst <= #2 0;
                ALUSrc <= #2 1;
                MemToReg <= #2 0;
                RegWrite <= #2 1;
                MemRead <= #2 0;
                MemWrite <= #2 0;
                Branch <= #2 0;
                Jump <= #2 0;
                SignExtend <= #2 1'b1;
                ALUOp <= #2 `SLT;
            end
			
			//Datapath selection for Unsigned Shift Left Immediate
			`SLTIUOPCODE: begin
                RegDst <= #2 0;
                ALUSrc <= #2 1;
                MemToReg <= #2 0;
                RegWrite <= #2 1;
                MemRead <= #2 0;
                MemWrite <= #2 0;
                Branch <= #2 0;
                Jump <= #2 0;
                SignExtend <= #2 1'b1;
                ALUOp <= #2 `SLTU;
            end
			
			//Datapath selection for XOR Immediate
			`XORIOPCODE: begin
                RegDst <= #2 0;
                ALUSrc <= #2 1;
                MemToReg <= #2 0;
                RegWrite <= #2 1;
                MemRead <= #2 0;
                MemWrite <= #2 0;
                Branch <= #2 0;
                Jump <= #2 0;
                SignExtend <= #2 1'b0;
                ALUOp <= #2 `XOR;
            end
			
			//Datapath selection for Default Case
            default: begin
                RegDst <= #2 1'bx;
                ALUSrc <= #2 1'bx;
                MemToReg <= #2 1'bx;
                RegWrite <= #2 1'bx;
                MemRead <= #2 1'bx;
                MemWrite <= #2 1'bx;
                Branch <= #2 1'bx;
                Jump <= #2 1'bx;
                SignExtend <= #2 1'bx;
                ALUOp <= #2 4'bxxxx;
            end
        endcase
    end
endmodule

