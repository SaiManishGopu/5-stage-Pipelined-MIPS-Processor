`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Texas A&M University
// ECEN-651 Microprogrammed Control of Digital Systems
// Lab			: Lab-6
// Created by	: Sai Manish Gopu
// UIN 			: 334003269
// Design		: Design of Pipelined MIPS Processor
//////////////////////////////////////////////////////////////////////////////////
module PipelinedProc(input CLK, Reset_L,
					input [31:0]startPC, 
					output [31:0]dMemOut
					);
	//Stage 1
	reg [31:0]currentPC; 
	wire [31:0]currentPCPlus4, nextPC;
	wire [31:0] currentInstruction;
	//Stage 2
    reg [31:0]currentInstruction2;
	wire [31:0] busA, busB, signExtImm, jumpTarget ,jumpDescisionTarget;
	wire [5:0] func3;
	reg [1:0]EX_AluOpCtrl_A, EX_AluOpCtrl_B;
	reg [31:0]ID_EX_shift; 
	wire [31:0]id_shift;
	wire IFWrite, PCWrite, bubble;
    wire [1:0]addrSel;
	wire regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jump, signExtend, UseShiftField;
	wire [3:0]aluOp;
	wire Data_Mem_Fwrd_Ctrl_EX, Data_Mem_Fwrd_Ctrl_MEM;
	reg  Data_Mem_Fwrd_Ctrl_EX3, Data_Mem_Fwrd_Ctrl_MEM3;
	wire [1:0] ID_AluOpCtrl_A, ID_AluOpCtrl_B;
	wire [31:0] Immediate_value3;
	wire [5:0] opcode;
	wire [4:0] rs, rt, rd;
	wire [15:0] imm16;
	wire [4:0] shamt;
	wire [5:0] func;
	wire rtUsed,rsUsed;
	//Stage 3
	reg memToReg3;
	reg  [3:0]aluOp3;
	reg  regDst3, regWrite3, memRead3, memWrite3;
	reg [31:0] signExtImm3;
	reg [20:0] currentInstruction3;
	reg [31:0] busA3, busB3 ;
	wire EX_Branch, EX_Jump, EX_SignExtend, EX_UseShmt;
	reg memToReg4;
	wire  [3:0] aluCtrl;
	wire [31:0] advanced_shift;
	wire [4:0]rw3;
	wire [31:0] DataIn3, EX_ALU_A, EX_ALU_B, aluOut3, shiftedSignExtImm, branchDst;
	wire aluZero3;
	//Stage 4
	reg  EX_MEM_RegDst, regWrite4, memRead4, memWrite4;
	reg  [31:0]aluOut4, DataIn4;
	reg   DataMemForwardCtrl_MEM4;
	reg  [4:0]rw4;
	wire [31:0] memOut, MemData_MuxOut;
	//Stage 5
	reg [31:0]memOut5, aluOut5;
	reg  [4:0]rw5;
	reg memToReg5;
	reg   regWrite5; 
	wire [31:0] regWriteData;
	assign dMemOut = memOut5;
	
	//Stage 1 Logic
	always @(negedge CLK)  //Logic for PC counter
		begin	                         
			if (~Reset_L) 
				currentPC <= startPC;
			else if (PCWrite)
	 
                         	currentPC <= nextPC; 
		end 
	assign currentPCPlus4 = currentPC + 4 ; 
	//PC value if there is a jump or branch or default address
    assign jumpDescisionTarget = (addrSel == 2'b01) ? jumpTarget : currentPCPlus4;	
	assign nextPC = (addrSel == 2'b10) ? branchDst : jumpDescisionTarget;
	//Instantiating instruction memory
    InstructionMemory instrMemory(.Data(currentInstruction), .Address(currentPC));
	
	//Stage 2 logic
	always@(negedge CLK or negedge Reset_L) begin
		if (~Reset_L)  
			currentInstruction2 <= 0;
		else if (IFWrite) 
			currentInstruction2 <= currentInstruction;
	end
	assign {opcode, rs, rt, rd, shamt, func} = currentInstruction2;
	assign imm16 = currentInstruction2[15:0];
	//Instantiating pipelined control unit
	PipelinedControl Controller (.RegDst(regDst),
				.ALUSrc(aluSrc), 
				.MemToReg(memToReg), 
				.RegWrite(regWrite), 
				.MemRead(memRead), 
				.MemWrite(memWrite), 
				.Branch(branch), 
				.Jump(jump), 
				.SignExtend(signExtend),
				.ALUOp(aluOp), 
				.Opcode(opcode),
				.UseShamt(UseShiftField),
				.Function(func)											
				);
				
	assign #2 rsUsed = (opcode != 6'b001111/*LUI*/) & ~UseShiftField;
	assign #1 rtUsed = (opcode == 6'b0) || branch || (opcode == 6'b101011/*SW*/);
	//Instantiating Hazard unit
	Hazard hazard ( .IF_Write(IFWrite), 
							.PC_Write(PCWrite), 
							.bubble(bubble), 
							.addrSel(addrSel), 
							.Jump(jump), 
							.Branch(branch), 
							.ALUZero(aluZero3), 
							.memReadEX(memRead3), 
							.CurrRs(rsUsed ? rs : 5'd0), 
							.CurrRt(rtUsed ? rt : 5'd0), 
							.PrevRw(currentInstruction3[20:16]), 
							.UseShmt(UseShiftField), 
							.UseImmed(aluSrc),
							.Clk(CLK),
							.Rst(Reset_L));
							
	//Instantiating Register file
	RegisterFile Registers (  .Busw(regWriteData),
							  .BusA(busA), 
							  .BusB(busB),
							  .rs(rs), 
							  .rt(rt), 
							  .rw5(rw5), 
							  .regWrite5(regWrite5), 
							  .CLK(CLK), 
							  .Reset_L(Reset_L)); 
	//Instantiating Sign Extension						  
	SignExtender immExt (.in(imm16), .signExtend(signExtend), .out(signExtImm));
	//Calculating Jump Address
	assign jumpTarget = {currentPC[31:28], currentInstruction2[25:0], 2'b00};
	assign id_shift = busB>>(currentInstruction2[10:6]);
	//Instatntiating Forwarding Unit	
	ForwardingUnit ForwardingUnit (.UseShamt(UseShiftField),
								  .UseImmed(aluSrc), 
								  .ID_Rs(rs), 
								  .ID_Rt(rt),
								  .EX_Rw(rw3),
								  .MEM_Rw(rw4),
								  .EX_RegWrite(regWrite3), 
								  .MEM_RegWrite(regWrite4), 
								  .AluOpCtrlA(ID_AluOpCtrl_A),
								  .AluOpCtrlB(ID_AluOpCtrl_B), 
								  .DataMemForwardCtrl_EX(Data_Mem_Fwrd_Ctrl_EX), 
								  .DataMemForwardCtrl_MEM(Data_Mem_Fwrd_Ctrl_MEM)
								);
	
	

//Stage 3 logic
always@(negedge CLK or negedge Reset_L) begin
if(~Reset_L) 
begin
	busA3 <= 0;
	busB3 <= 0;
	signExtImm3 <= 0;
	ID_EX_shift <= 0;
	currentInstruction3 <= 0;
	regDst3 <= 0;
	aluOp3 <=0;
	memRead3 <= 0;
	memWrite3 <= 0;
	regWrite3 <= 0;
	memToReg3 <= 0;
	EX_AluOpCtrl_A <= 0;
	EX_AluOpCtrl_B <=0;
	Data_Mem_Fwrd_Ctrl_EX3 <= 0;
	Data_Mem_Fwrd_Ctrl_MEM3 <= 0;
end
else if(bubble) //Introducing Stall if needed
begin
        busA3 <= busA;
        busB3 <= busB;
        signExtImm3 <= signExtImm;	
	    currentInstruction3 <= currentInstruction2[20:0];
	    regDst3 <= regDst;
	    aluOp3 <= aluOp;
	    ID_EX_shift <= id_shift;
	    memRead3 <= 0;
	    memWrite3 <= 0;
	    regWrite3 <= 0;
	    memToReg3 <= 0;
        EX_AluOpCtrl_A <= ID_AluOpCtrl_A;
        EX_AluOpCtrl_B <=ID_AluOpCtrl_B;
        Data_Mem_Fwrd_Ctrl_EX3 <= Data_Mem_Fwrd_Ctrl_EX;
        Data_Mem_Fwrd_Ctrl_MEM3 <= Data_Mem_Fwrd_Ctrl_MEM;
end
else							
begin
	busA3 <= busA;
	busB3 <= busB;
	signExtImm3 <= signExtImm;
	currentInstruction3 <= currentInstruction2;
	regDst3 <= regDst;
	aluOp3 <=aluOp;
        ID_EX_shift <= id_shift;
	memRead3 <= memRead;
	memWrite3 <= memWrite;
	regWrite3 <= regWrite;
	memToReg3 <= memToReg;
	EX_AluOpCtrl_A <= ID_AluOpCtrl_A;
	EX_AluOpCtrl_B <=ID_AluOpCtrl_B;
	Data_Mem_Fwrd_Ctrl_EX3 <= Data_Mem_Fwrd_Ctrl_EX;
	Data_Mem_Fwrd_Ctrl_MEM3 <= Data_Mem_Fwrd_Ctrl_MEM;	
end
end
	assign func3 = signExtImm3[5:0];
	assign advanced_shift = ID_EX_shift;
	//Instantiating ALUControl
	ALUControl mainALUControl(.ALUCtrl(aluCtrl), .ALUop(aluOp3), .FuncCode(func3));
	//Instantiating ALU
	ALU mainALU (.BusA(EX_ALU_A), .BusB(EX_ALU_B), .ALUCtrl(aluCtrl), .BusW(aluOut3), .Zero(aluZero3), .shmt(currentInstruction3[10:6]), .shift(advanced_shift));
	//Instantiating MUX
	mux4_to_1_A ex_mux4to1_A (.zero(busA3) , .one(aluOut4), .two(regWriteData), .select(EX_AluOpCtrl_A), .out(EX_ALU_A));
	mux4_to_1_B ex_mux4to1_B (.three(signExtImm3) ,.two(regWriteData), .one(aluOut4), .zero(busB3), .select(EX_AluOpCtrl_B), .out(EX_ALU_B));
	assign DataIn3 = (Data_Mem_Fwrd_Ctrl_EX3) ? regWriteData : busB3;
	assign rw3 = (regDst3) ? currentInstruction3[15:11] :currentInstruction3[20:16];	
	assign shiftedSignExtImm = {signExtImm3[29:0], 2'b0};
	assign branchDst = shiftedSignExtImm+ currentPC;
	
//Stage 4 logic
always@(negedge CLK or negedge Reset_L) begin
	if(!Reset_L)
	begin
		rw4 <= 0;
		DataIn4 <= 0;
		DataMemForwardCtrl_MEM4 <= 0;
		aluOut4 <= 0;
		memRead4 <= 0;
		memWrite4 <= 0;
		regWrite4 <= 0;
		memToReg4 <= 0;		
	end			
	else
	begin 
		rw4 <= rw3;
		DataIn4 <= DataIn3;
		DataMemForwardCtrl_MEM4 <= Data_Mem_Fwrd_Ctrl_MEM3;
		aluOut4 <= aluOut3;
		memRead4 <= memRead3;
		memWrite4 <= memWrite3;
		regWrite4 <= regWrite3;
		memToReg4 <= memToReg3;
	end
end	
	//Instantiating Data Memory
    DataMemory DataMemory ( .Clock(CLK), 
                    .MemoryRead(memRead4),  
                    .MemoryWrite(memWrite4), 
                    .Address(aluOut4[5:0]), 
                    .ReadData(memOut), 
                    .WriteData(MemData_MuxOut)
                    );
                    
assign MemData_MuxOut = (DataMemForwardCtrl_MEM4) ?  regWriteData : DataIn4;

//Stage 5 logic
always@(negedge CLK, negedge Reset_L) begin
	if(!Reset_L)
	begin
		memOut5 <= 0;    
		aluOut5 <= 0;
		rw5 <= 0;
		regWrite5 <= 0;
		memToReg5 <= 0;
		end
	else 
	begin
		memOut5 <= memOut;
		aluOut5 <= aluOut4;
		rw5 <= rw4;
		regWrite5 <= regWrite4;
		memToReg5 <= memToReg4;
	end
end
assign #1 regWriteData =  (memToReg5 == 1) ? memOut5 : aluOut5; 
	
endmodule
