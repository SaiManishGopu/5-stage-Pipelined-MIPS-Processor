`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////
// Texas A&M University
// ECEN-651 microprogrammed control of Digital systems
// Lab	       : Lab3
// File name   : DataMemory.v
// Created by  : Sai Manish Gopu
// UIN         : 334003269
// Design      : Designing a simple dta memory module
// Not for external use other than Texas A&M University
//////////////////////////////////////////////////////////////////////////


module DataMemory(input wire [5:0] Address , 
                  input wire [31:0] WriteData ,
                  input wire MemoryRead , 
                  input wire MemoryWrite , 
                  input wire Clock,
                  output reg [31:0] ReadData);
                  
reg [31:0] register[63:0];

//Reading the data from the Memory at the positive edge of clock
always@(posedge Clock)
begin
    if(MemoryRead)
    ReadData<= register[Address];
end

//Writing the data from the Memory at the negative edge of clock
always@(negedge Clock)
begin
    if(MemoryWrite)
    register[Address]<=WriteData;
end
                  
endmodule

