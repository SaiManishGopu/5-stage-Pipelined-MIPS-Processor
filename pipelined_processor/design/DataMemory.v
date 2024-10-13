`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Texas A&M University
// ECEN-651 Microprogrammed Control of Digital Systems
// Lab			: Lab-6
// Created by	: Sai Manish Gopu
// UIN 			: 334003269
// Design		: Design of Pipelined MIPS Processor
//////////////////////////////////////////////////////////////////////////////////

module DataMemory (input Clock, 
				input MemoryRead,  
				input MemoryWrite, 
				input [5:0]Address,
				output reg [31:0]ReadData,
				input [31:0]WriteData ); 
				
		reg [31:0]datamem[63:0];
		
		
	always @(posedge Clock)   //memory read operation
        begin
             if (MemoryRead == 1)  
                     ReadData <= datamem[Address];
        end
      
     always @(negedge Clock)  //memory write operation
         begin
              if(MemoryWrite == 1) 
                      datamem[Address] <= WriteData;
         end
        				
endmodule