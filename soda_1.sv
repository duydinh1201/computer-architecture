`include "ctmt/library/Sub_n.sv"
`include "ctmt/library/DffSync_n_data.sv"
`include "ctmt/library/mux2to1_n.sv"
`include "ctmt/library/dff_n_data.sv"

module soda_1(
	input logic nickle_i,
	input logic dime_i,
	input logic quater_i,
	input logic clk_i,
	input logic rst_i,
	output logic soda_o,
	output logic[2:0] change_o
);
//main
	logic[5:0] nickle_o,dime_o,quater_o;
	DffSync_n_data#(6,0) Nickle(0,5+sum,sign,rst_i,(!sign)?clk_i:clk_i&nickle_i,nickle_o);
	DffSync_n_data#(6,0) Dime(0,10+sum,sign,rst_i,(!sign)?clk_i:clk_i&~nickle_i&dime_i,dime_o);
	DffSync_n_data#(6,0) Quater(0,25+sum,sign,rst_i,(!sign)?clk_i:clk_i&~nickle_i&~dime_i&quater_i,quater_o);
//tong tien va dk dung
	logic[5:0] sum,sub;
	logic sign;
	assign	sum=nickle_o+dime_o+quater_o;
	Sub_n#(6) SUB(0,sum,20,clk_i,sub,sign);
//change
	logic [2:0] change;
	always_comb begin
	case(sub)
	default: change=0;
	5: change=1;
	10: change=2;
	15: change=3;
	20: change=4;
	endcase
end
	assign  change_o=(~sign)?change:0;
	assign	soda_o=~sign;
endmodule:soda_1
