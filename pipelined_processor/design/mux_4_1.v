//////////////////////////////////////////////////////////////////////////////////
// Texas A&M University
// ECEN-651 Microprogrammed Control of Digital Systems
// Lab			: Lab-6
// Created by	: Sai Manish Gopu
// UIN 			: 334003269
// Design		: Design of Pipelined MIPS Processor
//////////////////////////////////////////////////////////////////////////////////
module mux4_to_1_B(input [31:0]zero , input [31:0]one, input [31:0]two, input [31:0]three, input [1:0]select, output reg [31:0]out);
	always @(*) begin
		case(select)
			2'b00 : out <= zero;
			2'b01 : out <= one;
			2'b10 : out <= two;
			default : out <= three;
		endcase
	end
endmodule
