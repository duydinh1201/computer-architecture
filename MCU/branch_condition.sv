`include "ctmt/MCU/brcomp.sv"
module branch_condition#(parameter n=32) (is_branch,data1_i,data2_i,opcode_i,clk_i,en_jump);
input logic[n-1:0] data1_i,data2_i;
input logic clk_i;
input logic is_branch;
input logic[2:0] opcode_i;
output logic en_jump;
////////////////////main//////////////////
	logic br_signed,br_less,br_equal;
	assign br_signed=(opcode_i==6 || opcode_i==7)?0:1;
	brcomp#(n) BRCOMP(data1_i,data2_i,br_signed,clk_i,br_less,br_equal);
	always_comb begin:proc
	if(is_branch)
		case(opcode_i)
			0:     en_jump=br_equal;
			1:     en_jump=~br_equal;
			4:     en_jump=br_less;
			5:     en_jump=~br_less;
			6:     en_jump=br_less;
			7:     en_jump=~br_less;
			default:en_jump=0;
		endcase
	else en_jump=0;
	end
endmodule:branch_condition
