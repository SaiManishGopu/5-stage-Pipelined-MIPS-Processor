`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Texas A&M University
// ECEN-651 Microprogrammed Control of Digital Systems
// Lab			: Lab-6
// Created by	: Sai Manish Gopu
// UIN 			: 334003269
// Design		: Design of Pipelined MIPS Processor
//////////////////////////////////////////////////////////////////////////////////
module Hazard(
	input Jump, 
	input Branch, 
	input ALUZero, 
	input memReadEX, 
	input Clk,
	input Rst,
	input UseImmed, 
	input UseShmt,
	input [4:0] CurrRt, CurrRs, PrevRw,
	
	output reg IF_Write, 
	output reg PC_Write, 
	output reg bubble,  
	output reg [1:0]addrSel);

	reg LoadHazard;
    reg [2:0] FSM_state, FSM_nxt_state;
    
	//Defining FSM States
	parameter NO_HAZARD  = 2'b00;
	parameter JUMP	     = 2'b01;
	parameter BRANCH_0   = 2'b10;
	parameter BRANCH_1   = 2'b11;
    
	//Logic for RAW Hazard detection           
    always @ (*) 
		begin
            if (PrevRw != 0) 
				begin
					if (memReadEX == 1'b1 && UseImmed == 1'b0 && UseShmt == 1'b0) 
						begin
							if((CurrRs == PrevRw) || (CurrRt == PrevRw)) 
							LoadHazard <= 1'b1;
							else
							LoadHazard <= 1'b0;
						end
					else if (UseShmt == 1'b1 && memReadEX == 1'b1 && UseImmed == 1'b0) 
						begin
							if(CurrRs == PrevRw) 
							LoadHazard <= 1'b1;
							else
							LoadHazard <= 1'b0;
						end
					else if (UseShmt == 1'b0 && memReadEX == 1'b1 && UseImmed == 1'b1) 
						begin
							if(CurrRs == PrevRw)  
							LoadHazard <= 1'b1;
							else
							LoadHazard <= 1'b0;
						end
					else LoadHazard <= 1'b0;
				end
            else LoadHazard <= 1'b0;
        end
        
     //FSM for Hazard detection Unit  
     always @(posedge Clk, negedge Rst) 
		begin
			if (!Rst) 
				begin
					FSM_state <= NO_HAZARD;
				end
			else 
				begin
					FSM_state <= FSM_nxt_state;
				end
		end
		
      //Combinational Logic for FSM        
        always @(*) begin
            case (FSM_state)
         NO_HAZARD : begin
				if (Jump == 1'b1) begin
					                FSM_nxt_state <= JUMP;
					                PC_Write <= 1'b1;
                                	IF_Write <= 1'b1;
                                	bubble <= 1'b0;
                                	addrSel <= 2'b00;
								end
                else if (LoadHazard == 1'b1) begin
					                FSM_nxt_state <= NO_HAZARD; 
					                PC_Write <= 1'b0;
                                	IF_Write <= 1'b0;
                                	bubble <= 1'b1;  //Stall for one cycle
                                	addrSel <= 2'b00;
								end
                else if (Branch == 1'b1) begin 
					                FSM_nxt_state <= BRANCH_0;
					                PC_Write <= 1'b1;
                                	IF_Write <= 1'b1;
                                	bubble <= 1'b0;
                                	addrSel <= 2'b00;
								end
                else 			begin 
									FSM_nxt_state <= NO_HAZARD;
                                	PC_Write <= 1'b1;
                                	IF_Write <= 1'b1;
                                	bubble <= 1'b0;
                                	addrSel <= 2'b00;
                                end
               end                          
		JUMP        :   begin
                          FSM_nxt_state <= NO_HAZARD;
                          PC_Write <=1'b1;
                          IF_Write <=1'b0;
                          bubble <= 1'b1;  //Stall for one cycle
                          addrSel <= 2'b01;                                   
                        end
                                                         
        BRANCH_0   :   begin
                          if (!ALUZero) begin
							FSM_nxt_state <= NO_HAZARD;
                            PC_Write <=1'b0;
                            IF_Write <=1'b0;
                            bubble <= 1'b1; //Stall for one cycle
                            addrSel <= 2'b00;  
						    end
                         else begin
							 FSM_nxt_state <= BRANCH_1;
                             PC_Write <=1'b0;
                             IF_Write <=1'b0;
                             bubble <= 1'b1; //Stall for one cycle
                             addrSel <= 2'b00; 
                               end
						end
                                                         
        BRANCH_1   :     begin
                             FSM_nxt_state <= NO_HAZARD;
                             PC_Write <=1'b1;
                             IF_Write <=1'b0;
                             bubble <= 1'b1; //Stall for one cycle
                             addrSel <= 2'b10;
                           end
        default   :      begin
                             FSM_nxt_state <= FSM_state;
                             PC_Write <= 1'b0;
                             IF_Write <= 1'b0;
                             bubble <= 1'b0;
                             addrSel <= 2'b00;
                          end
                                                                     
                  endcase
			end
       
     
endmodule
