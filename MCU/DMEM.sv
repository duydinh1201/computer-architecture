//`include "ctmt/library/mux4096to1_n.sv"
`include "ctmt/library/mux64to1_n.sv"
`include "ctmt/library/dff_n_data.sv"
module DMEM#(parameter n=8,address=11)
(
  input logic clk_i,
  input logic rst_ni,
  input logic [address-1:0] addr_i,
  input logic [address-1:0] addr_test,
  input logic [n-1:0] st_data_i,
  input logic st_en_i,
  output  logic [n-1:0] ld_data_o
);
// DMEM
parameter x=64;//2**address/z
parameter m=6;//=log2(x)
parameter z=32;//=2**address/64
parameter s=5;//=log2(z)
//decoder  
logic ena_addr_o[0:z-1][0:x-1];
always_comb begin
  for(int i=0;i<z;i++)begin
  	for(int j=0;j<x;j++)begin
  	 ena_addr_o[i][j]=0;
  	 st_data_o[i][j] = st_data_i;
  	end
  end
   ena_addr_o[addr_i[address-1:m]][addr_i[m-1:0]]=1;
end
//tao mang register
logic[n-1:0] ld_data_i[0:z-1][0:x-1],st_data_o[0:z-1][0:x-1];
genvar a, b;
	generate
	for (b = 0; b < z; b++) begin
	   for (a = 0; a < x; a++) begin
	     dff_n_data#(n,0) Reg(st_data_o[b][a],rst_ni,clk_i& ena_addr_o[b][a] &st_en_i,ld_data_i[b][a]);
	   end
	 end
   endgenerate
//encoder
logic[n-1:0]	data_i1[0:z-1];
	//tang dau
genvar c;
	generate
	for (c = 0; c < z; c++) begin
		mux64to1_n#(n) stage_1a(ld_data_i[c],addr_test[address-s-1:0],data_i1[c]);
	   end
   endgenerate
	//tang sau
	mux32to1_n#(n) stage_2(data_i1,addr_test[address-1:address-s],ld_data_o);
//	mux2048to1_n#(n) Encoder(ld_data_i,addr_test,ld_data_o);
//	mux1024to1_n#(n) Encoder(ld_data_i,addr_test,ld_data_o);
//	mux4096to1_n#(n) Encoder(ld_data_i,addr_test,ld_data_o);
//	mux2048to1_n#(n) Encoder(ld_data_i,addr_i,ld_data_o);
endmodule:DMEM
