`include "ctmt/library/mux1024to1_n.sv"
module mux2048to1_n#(parameter n=32)(
	input logic[n-1:0] data_i[0:2**address-1],
//	input logic clk_i,
	input logic [address-1:0] sel,	
	output logic[n-1:0] data_o
);
parameter address=11;
parameter gr=2;//=2**address/1024
parameter m=1024;//=2**address/gr
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
logic[n-1:0]	data_i1[0:gr-1];
genvar a;
	generate
	for (a = 0; a < gr; a++) begin
		mux1024to1_n#(n) stage_1a(data[a],sel[address-s-1:0],data_i1[a]);
	   end
   endgenerate
//tang sau
    	mux2to1_n#(n) stage_1a(data_i1[0],data_i1[1],sel[address-1:address-s],data_o);
endmodule:mux2048to1_n
