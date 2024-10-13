`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// ECEN-651 microprogrammed control of Digital systems
// Lab	       : Lab4
// File name   : ALU.v
// Created by  : Sai Manish Gopu
// UIN         : 334003269
// Design      : Designing a ALU Module
// Not for external use other than Texas A&M University
//////////////////////////////////////////////////////////////////////////

`define AND 4'b0000
`define OR 4'b0001
`define ADD 4'b0010
`define SLL 4'b0011
`define SRL 4'b0100
`define SUB 4'b0110
`define SLT 4'b0111
`define ADDU 4'b1000
`define SUBU 4'b1001
`define XOR 4'b1010
`define SLTU 4'b1011
`define NOR 4'b1100
`define SRA 4'b1101
`define LUI 4'b1110

module ALU(BusW, Zero, BusA, BusB, ALUCtrl);

input wire [31:0] BusA, BusB;
output reg [31:0] BusW;
input wire [3:0] ALUCtrl ;
output reg Zero ;

always@(*)begin	
	
	case (ALUCtrl)
	`AND:   BusW <= BusA&BusB;
	`OR:    BusW <= BusA|BusB;
	`ADD:   BusW <= $signed(BusA)+$signed(BusB);
	`ADDU:  BusW <= BusA+BusB;
	`SLL:   BusW <= BusB<<BusA;
	`SRL:   BusW <= BusB>>BusA;
	`SUB:   BusW <= $signed(BusA)-$signed(BusB);
	`SUBU:  BusW <= BusA-BusB;
	`XOR:   BusW <= BusA^BusB;
	`NOR:   BusW <= ~(BusA|BusB);
	`SLT:   BusW <= ($signed(BusA) < $signed(BusB)) ? 32'h1 : 32'h0;
	`SLTU:  BusW <= (BusA < BusB) ? 32'h1 : 32'h0;
	`SRA:   BusW <= ($signed(BusB))>>>BusA;
	`LUI:   BusW <= {BusB[15:0],16'b0};
	default:BusW <= 0;
	endcase
end

always @(BusW) 
begin
		if (BusW == 0) 
		begin
			Zero <= 1;
		end 
		else 
		begin
			Zero <= 0;
		end
end

endmodule
