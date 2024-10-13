`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// ECEN-651 microprogrammed control of Digital systems
// Lab	       : Lab3
// File name   : RegisterFile.v
// Created by  : Sai Manish Gopu
// UIN         : 334003269
// Design      : Designing a 32-by-32 Register File
// Not for external use other than Texas A&M University
//////////////////////////////////////////////////////////////////////////

module RegisterFile(input wire [31:0] BusW ,
                    input wire [4:0] RA, 
                    input wire [4:0] RB , 
                    input wire [4:0] RW, 
                    input wire RegWr ,
                    input wire Clk, 
                    output reg [31:0] BusA , 
                    output reg [31:0] BusB);

//Defining local variable register file
reg [31:0] register[31:0];

//Assigning the 0th register 0
initial
begin
register[0]=32'b0;
end

//Reading the data from the Register File
always@*
begin
BusA<=register[RA];
BusB<=register[RB];
end

//Writing the data into the Register File at the negative edge of clock
always@(negedge Clk)
begin
if(RegWr==1)
begin
    if(RW!=5'b0)
    register[RW]<=BusW;
    end
end

endmodule

