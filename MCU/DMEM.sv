`include "ctmt/library/mux32to1_n.sv"
`include "ctmt/library/dff_n_data.sv"
`include "ctmt/library/dff_n.sv"
module DMEM#(parameter n=32,address=5)
(
  input clk_i,
  input rst_ni,
  input [address-1:0] addr_i,//lay 12 bit dia chi 
  input [n-1:0] st_data_i,
  input st_en_i,
 // input [n-1:0] io_sw_i,
  output reg [n-1:0] ld_data_o
 /* output reg [n-1:0] io_lcd_o,
  output reg [n-1:0] io_ledg_o,
  output reg [n-1:0] io_ledr_o,
  output reg [n-1:0] io_hex_o*/
);
// DMEM
parameter x=8;//tu chon ngau nhien
parameter m=3;//=log2(x)
parameter y=2;//=log2(2**address/x)
parameter z=4;//=2**address/x
logic[n-1:0] ld_data_i[0:2**address-1],st_data_o[0:2**address-1];
//decoder 12 bit dia chi tuong duong 
logic ena_addr_o[0:2**address/x-1][0:x-1];
logic[address-1:0] ena_addr;
logic[address-1:0] div;
always_comb begin
   div=(addr_i/x);
   ena_addr=addr_i%x;
  for(int i=0;i<(2**address)/x;i++)begin
  	for(int j=0;j<x;j++)begin
  	 ena_addr_o[i][j]=0;
  	end
  end
   ena_addr_o[div[y-1:0]][ena_addr[m-1:0]]=1;
end
//khoi tao gia tri store
	always_comb begin
	    for (int i = 1; i < 2**address; i++) begin
	        st_data_o[i] = st_data_i;
	    end
	end
//tao mang register
genvar a, b;
	generate
	for (b = 0; b < z; b++) begin
	   for (a = 0; a < x; a++) begin
	     dff_n_data#(n,0) Reg(st_data_o[b*x + a],rst_ni,clk_i& ena_addr_o[b][a] &st_en_i,ld_data_i[b*x + a]);
	   end
	 end
   endgenerate
//encoder
	mux32to1_n#(n) Encoder(ld_data_i,addr_i,ld_data_o);
//not use
logic notuse,notuse_o;
	always_comb begin
		notuse=0;
		for(int i=m;i<address;i++) begin
			notuse |=ena_addr[i];
		end
		for(int i=y;i<address;i++) begin
			notuse |=div[i];
		end
	end
	dff_n#(1) Notuse(notuse|notuse_o,clk_i,notuse_o);
endmodule:DMEM
