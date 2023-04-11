`include "ctmt/library/mux128to1_n.sv"
`include "ctmt/library/dff_n_data.sv"
//`include "ctmt/library/store_ctl.sv"

module dmem_new#(parameter n=32,address=10)
(
//  input logic[3:0] op_ls,
  input logic clk_i,
  input logic rst_ni,
  input logic [address-1:0] addr_i,
//  input logic [address-1:0] addr_test,
  input logic [n-1:0] st_data_i,
  input logic st_en_i,
  output  logic [n-1:0] ld_data_o,
  output  logic [n-1:0] perh_o[0:10]
);
// DMEM
parameter x=128;//chon bo mux128to1
parameter m=7;//=log2(x)
parameter z=addr/x;
parameter addr=2**address;
///////////////////////////decoder////////////////////////////////  
		logic ena_addr_o[0:z-1][0:x-1];
		always_comb begin
		  for(int i=0;i<z;i++)begin
		  	for(int j=0;j<x;j++)begin
		  	 ena_addr_o[i][j]=0;
		 	 st_data_o[i][j]= st_data_i;
		  	end
		  end
		   ena_addr_o[addr_i[address-1:m]][addr_i[m-1:0]]=1;
		   //ena_addr_o[addr_i[address-1:mask]][addr_i[mask-1:0]]=1;
		end
/////////////////////tao mang register///////////////////////
	logic[n-1:0]  st_data_o[0:z-1][0:x-1];
	logic[n-1:0]  reg_out[0:z-1][0:x-1];

	genvar a,b;
		generate
			for (b = 0; b < z; b++) begin
			   for (a = 0; a < x; a++) begin
			     dff_n_data#(n,0) Reg(st_data_o[b][a],rst_ni,clk_i& ena_addr_o[b][a] &st_en_i,reg_out[b][a]);
			   end
			 end
	   endgenerate
//ghi vao file datamem.data

 always_ff@(posedge clk_i) begin
 	if(st_en_i)
			$writememh("ctmt/MCU/datamem.data",reg_out);
	end

///////////////////////encoder//////////////////////
	/*	logic[n-1:0] reg_out_i[0:z-1][0:x-1];
		always_comb begin:chia_mang
				for (int i=0; i < z; i++) begin
			   		for (int j = 0; j < x; j++) begin
			   			reg_out_i[i][j]=reg_out[i*x+j];
			   		end
			   	end
		end*/
		logic [n-1:0] ld_data[0:z-1];
		genvar d1;
			generate
			for (d1 = 0; d1 < z; d1++) begin
				mux128to1_n#(n) Encoder(reg_out[d1],addr_i[m-1:0],ld_data[d1]);
			 end
		   endgenerate
		always_comb begin:encoder
				case(addr_i[address-1:m]) 
					addr_i[address-1:m]: ld_data_o=ld_data[addr_i[address-1:m]];
				default: ld_data_o=0;
				endcase 
			end
//////////////////////peripherals output///////////////////////////
	always_comb begin
	  for(int i=0;i<11;i++) begin
		  perh_o[i]=reg_out[2][i*4];
	  	 end
	 end
	
endmodule:dmem_new
