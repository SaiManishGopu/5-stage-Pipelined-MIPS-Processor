//////////////////////////////////////////////////////////////////////////////////
// Texas A&M University
// ECEN-651 Microprogrammed Control of Digital Systems
// Lab			: Lab-6
// Created by	: Sai Manish Gopu
// UIN 			: 334003269
// Design		: Design of Pipelined MIPS Processor
//////////////////////////////////////////////////////////////////////////////////
module SignExtender(input [15:0]in, input signExtend, output reg [31:0]out);
	always @(*) begin
	   if (signExtend == 0) begin
	       out <= 32'h0 + in;
	   end
	   else begin
	       out <= (in[15] ? (32'hffff0000 + in) : (32'h0 + in));
	   end
	end
endmodule

