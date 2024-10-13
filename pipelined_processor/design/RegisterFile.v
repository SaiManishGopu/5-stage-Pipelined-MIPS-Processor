//////////////////////////////////////////////////////////////////////////////////
// Texas A&M University
// ECEN-651 Microprogrammed Control of Digital Systems
// Lab			: Lab-6
// Created by	: Sai Manish Gopu
// UIN 			: 334003269
// Design		: Design of Pipelined MIPS Processor
//////////////////////////////////////////////////////////////////////////////////
module RegisterFile(
	input CLK,     
	input Reset_L,
	input [4:0]rs, 
	input [4:0]rt, 
	input [4:0]rw5, 
	input regWrite5,
	input [31:0] Busw,  
	output reg [31:0]BusA,
	output reg [31:0]BusB);
		 
reg [31:0] registerfile [0:31];  
  
  	integer i;
   	always@(posedge CLK) begin 
             if (!Reset_L) begin
		      for (i=0; i<32; i=i+1) 
			        registerfile[i] <= 32'h0;
            end else 
                if(regWrite5 && rw5 != 0)  
			registerfile[rw5] <= Busw;         
        end 
    always @(*) begin
                  BusA <= registerfile[rs];
                  BusB <= registerfile[rt];
            end 
endmodule
