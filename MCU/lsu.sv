`include "ctmt/MCU/DMEM.sv"
`include "ctmt/library/mux256to1_n.sv"
module lsu#(parameter n=32,address=12)(clk_i,rst_ni,addr_i,st_i,st_en_i,sw_i,ld_o,io_lcd_o,io_ledg_o,io_ledr_o,io_hex_o);
  input logic clk_i;
  input logic rst_ni;
  input logic [address-1:0] addr_i;
  input logic [n-1:0] st_i;
  input logic st_en_i;
  input logic[n-1:0] sw_i;
  output  logic [n-1:0] ld_o;
  output  logic [n-1:0] io_hex_o[0:7];
  output  logic [n-1:0] io_ledr_o;
  output  logic [n-1:0] io_ledg_o;
  output  logic [n-1:0] io_lcd_o;
//////////////////////////////////////////////////

//dmem
logic en_st_dmem;
	//neu dia chi be hon 0x3ff,store vao dmem
	assign en_st_dmem=(addr_i[address-1:10]==0)?st_en_i:0;
	DMEM#(32,10) dmem(clk_i,rst_ni,addr_i[9:0],st_i,en_st_dmem,ld_o);
//peripherals
 	parameter x=256;
	//decoder  
	logic ena_addr_o[0:x];
	logic rst_no;
	always_comb begin
		//khoi tao
	  	for(int j=0;j<=x;j++)begin
		  	 ena_addr_o[j]=0;
		  	 st_data_o[j] =st_i;
	  	end
	  	 //tao en_st co dia chi tu 1024->1024+256
	  	if(addr_i[address-1:10]==1)
	  		ena_addr_o[addr_i[8:0]]=1; //chan chon vi tri register 
	  	//ld_data_i[256] la gia tri sw_i,sw_i[17] is reset
		rst_no=ld_data_i[256][17]|~clk_i|notuse&0|st_en_i;
	end
	//tao mang register 
	logic[n-1:0] ld_data_i[0:x],st_data_o[0:x];
	genvar a;
		generate
		   for (a = 0; a <= x; a++) begin
		     dff_n_data#(n,0) Reg((a==256)?sw_i:st_data_o[a],//256(=0x500-0x3ff),la dia chi cua sw_i: 0x500,
		     					  (a<170 && a%16 == 0)?rst_no:rst_ni,                    //reset register
		     					  (a==256 && st_en_i==0)?clk_i:clk_i & ena_addr_o[a] & st_en_i,//clk register
		     					  ld_data_i[a]);	//ld_data_i[256] la gia tri cua sw_i
		   end
	   endgenerate
	//NOT USE don't care
	logic[n-1:0] notuse_o;
	logic notuse;
	mux256to1_n#(32) Encoder(ld_data_i[0:255],addr_i[7:0],notuse_o);
	always_comb begin:not_use
		notuse=0;
		for(int i=0;i<n;i++)
			notuse|=notuse_o[i];
		end	
	//peripherals output
	always_comb begin: per_out
		for(int i=0;i<11;i++)begin
		case(i)	
				0: io_hex_o[i] 	    =ld_data_i[256]&32'hffffff80|ld_data_i[i*16]&32'h0000007f;//lay 7 bit 
				1: io_hex_o[i] 	    =ld_data_i[256]&32'hffffff80|ld_data_i[i*16]&32'h0000007f;
				2: io_hex_o[i] 	    =ld_data_i[256]&32'hffffff80|ld_data_i[i*16]&32'h0000007f;
				3: io_hex_o[i] 	    =ld_data_i[256]&32'hffffff80|ld_data_i[i*16]&32'h0000007f;
				4: io_hex_o[i] 	    =ld_data_i[256]&32'hffffff80|ld_data_i[i*16]&32'h0000007f;
				5: io_hex_o[i] 	    =ld_data_i[256]&32'hffffff80|ld_data_i[i*16]&32'h0000007f;
				6: io_hex_o[i] 	    =ld_data_i[256]&32'hffffff80|ld_data_i[i*16]&32'h0000007f;
				7: io_hex_o[i] 	    =ld_data_i[256]&32'hffffff80|ld_data_i[i*16]&32'h0000007f;
				8:	io_ledr_o 		=ld_data_i[256]&32'hfffe0000|ld_data_i[i*16]&32'h0001ffff;//lay 17 bit
				9:	io_ledg_o  		=ld_data_i[256]&32'hffffff00|ld_data_i[i*16]&32'h000000ff;//lay 8bit
				10:io_lcd_o 		=ld_data_i[256]&32'hfffff800|ld_data_i[i*16]&32'h000007ff;// lay 11 bit
	         endcase
	     end
	end
endmodule:lsu
	
		
	
