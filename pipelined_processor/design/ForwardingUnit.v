`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Texas A&M University
// ECEN-651 Microprogrammed Control of Digital Systems
// Lab			: Lab-6
// Created by	: Sai Manish Gopu
// UIN 			: 334003269
// Design		: Design of Pipelined MIPS Processor
//////////////////////////////////////////////////////////////////////////////////
module ForwardingUnit( 
	input UseImmed, 
	input UseShamt,
	input [4:0]  ID_Rs, ID_Rt, 
	input [4:0] EX_Rw, MEM_Rw,
	input EX_RegWrite, MEM_RegWrite,
	output reg [1:0]AluOpCtrlA, 
	output reg [1:0] AluOpCtrlB,
	output reg DataMemForwardCtrl_EX, 
	output reg DataMemForwardCtrl_MEM);
	
	//Select line for Input MUX A of ALU
	always @(*) 
		begin
			if (UseShamt == 0 && EX_Rw!=0)
				begin
					if ( ID_Rs == EX_Rw && EX_RegWrite == 1) 
						AluOpCtrlA = 2'b01;
					else if ( ID_Rs == MEM_Rw && (MEM_Rw != EX_Rw || EX_RegWrite == 0) && MEM_RegWrite == 1) 
						AluOpCtrlA = 2'b10;
					else 
						AluOpCtrlA = 2'b00;
				end
			else if (UseShamt == 1) 
						AluOpCtrlA = 2'b11;
			else 
						AluOpCtrlA = 2'b00;	
		end
	
	//Select line for Input MUX B of ALU	
	always @(*) 
		begin
			if (UseImmed == 0 && EX_Rw!=0)
				begin					
					if (ID_Rt == EX_Rw && EX_RegWrite == 1) 
						AluOpCtrlB = 2'b01;
					else if (ID_Rt == MEM_Rw && (MEM_Rw != EX_Rw || EX_RegWrite == 0) && MEM_RegWrite == 1) 
						AluOpCtrlB = 2'b10;
					else 
						AluOpCtrlB = 2'b00;
				end
			else if (UseImmed == 1) 
						AluOpCtrlB = 2'b11;
			else 
						AluOpCtrlB = 2'b00;
		end
 	
	//Select line for MUXes at Stage 3 and 4
	always @(*) 
		begin
			if(MEM_RegWrite == 1 && ID_Rt == MEM_Rw)
				begin
					DataMemForwardCtrl_EX = 1'b1;
					DataMemForwardCtrl_MEM = 1'b0;
				end
			else
				begin
					if(EX_RegWrite == 1 && ID_Rt == EX_Rw)	
						begin
							DataMemForwardCtrl_EX = 1'b0;
							DataMemForwardCtrl_MEM = 1'b1;
						end
					else
						begin
							DataMemForwardCtrl_EX = 1'b0;
							DataMemForwardCtrl_MEM = 1'b0;
						end
				end	
		end
endmodule

