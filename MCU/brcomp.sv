//`include "ctmt/library/Sub_n.sv"
module brcomp#(parameter n=32)(
	input logic[n-1:0] rs1_d_i,
	input logic[n-1:0] rs2_d_i,
	input logic br_signed, //=0 unsigned
	input logic clk_i,	
	output logic br_less_o,
	output logic br_equal_o
);
	logic sub_sign,br_less_signed,br_less_unsigned;
	logic[n-1:0] sub;
	Sub_n#(n) SUB(br_signed,rs1_d_i,rs2_d_i,clk_i,sub,sub_sign);
	assign br_less_signed =(~rs1_d_i[n-1] &  sub_sign |
					   rs1_d_i[n-1] & ~rs2_d_i[n-1]|
					   rs1_d_i[n-1] &  rs2_d_i[n-1] & sub_sign  
					 )?1:0;
	assign br_less_unsigned=sub_sign;
	//br_less_o
	assign br_less_o=(!br_signed)?br_less_unsigned:br_less_signed;
	//br_equal_o
	assign br_equal_o=(sub==0)?1:0;
endmodule:brcomp
