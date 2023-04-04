`include "ctmt/library/mux2048to1_n.sv"
//`include "ctmt/library/mux4096to1_n.sv"
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
parameter x=64;//tu chon ngau nhien sao cho 2^address chia het cho x
parameter m=6;//=log2(x)
parameter z=32;//=2**address/x
//decoder 12 bit dia chi tuong duong 
logic ena_addr_o[0:z-1][0:x-1];
always_comb begin
  for(int i=0;i<z;i++)begin
  	for(int j=0;j<x;j++)begin
  	 ena_addr_o[i][j]=0;
  	end
  end
   ena_addr_o[addr_i[address-1:m]][addr_i[m-1:0]]=1;
end
//khoi tao gia tri store
	always_comb begin
	    for (int i = 1; i < 2**address; i++) begin
	        st_data_o[i] = st_data_i;
	    end
	end
//tao mang register
logic[n-1:0] ld_data_i[0:2**address-1],st_data_o[0:2**address-1];
genvar a, b;
	generate
	for (b = 0; b < z; b++) begin
	   for (a = 0; a < x; a++) begin
	     dff_n_data#(n,0) Reg(st_data_o[b*x + a],rst_ni,clk_i& ena_addr_o[b][a] &st_en_i,ld_data_i[b*x + a]);
	   end
	 end
   endgenerate
//encoder
	mux2048to1_n#(n) Encoder(ld_data_i,addr_test,ld_data_o);
//	mux4096to1_n#(n) Encoder(ld_data_i,addr_test,ld_data_o);
//	mux2048to1_n#(n) Encoder(ld_data_i,addr_i,ld_data_o);
endmodule:DMEM
