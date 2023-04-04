`include "ctmt/library/mux2to1_n.sv"
module mux4to1_n#(parameter n=4,address=2,m=4)(
	input logic[n-1:0] data_i[0:m-1],
//	input logic clk_i,
	input logic [address-1:0] sel,	
	output logic[n-1:0] data_o
);
logic[n-1:0] data_odd_1[0:m/2-1],data_even_1[0:m/2-1];
  always_comb begin
  	for(int i=0;i<m/2;i++) begin
	  	data_odd_1[i]=data_i[2*i+1];
	  	data_even_1[i]=data_i[2*i];
  	end
  end 
//tang dau
	logic[n-1:0]	data_i1[0:1];
	mux2to1_n#(n) stage_1a(data_even_1[0],data_even_1[1],sel[address-1:1],data_i1[0]);
	mux2to1_n#(n) stage_1b(data_odd_1[0],data_odd_1[1],sel[address-1:1],data_i1[1]);
//tang sau
	mux2to1_n#(n) stage_2(data_i1[0],data_i1[1],sel[0],data_o);
/*
//test don't care
	logic test,test_o;
 	assign test=0;
 	dff_n#(1) Test(test|test_o,clk_i,test_o);*/
endmodule:mux4to1_n
