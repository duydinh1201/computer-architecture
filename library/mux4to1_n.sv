`include "ctmt/library/mux2to1_n.sv"
module mux4to1_n#(parameter n=4)(
	input logic[n-1:0] data_i[0:2**address-1],
//	input logic clk_i,
	input logic [address-1:0] sel,	
	output logic[n-1:0] data_o
);
parameter address=2;
parameter m=2;//=2**address/gr
parameter gr=2;//=2**address/2
parameter s=1;//=log2(gr)
logic[n-1:0] data[0:gr-1][0:m-1];
  always_comb begin
  	for(int i=0;i<gr;i++) begin
  	 for(int j=0;j<m;j++) begin
	  	data[i][j]=data_i[i*m+j];
	  end
  	end
  end 
//tang dau
logic[n-1:0]	data_i1[0:1];
genvar b;
	generate
	for (b = 0; b < gr; b++) begin
		mux2to1_n#(n) stage_1a(data[b][0],data[b][1],sel[address-s-1:0],data_i1[b]);
	   end
   endgenerate
//tang sau
	mux2to1_n#(n) stage_2(data_i1[0],data_i1[1],sel[address-1:address-s],data_o);
/*
//test don't care
	logic test,test_o;
 	assign test=0;
 	dff_n#(1) Test(test|test_o,clk_i,test_o);*/
endmodule:mux4to1_n
