`include "ctmt/MCU/dmem_new.sv"
`include "ctmt/MCU/store_ctl.sv"
`include "ctmt/MCU/load_ctl.sv"
`include "ctmt/MCU/brcomp.sv"
`include "ctmt/library/dff_n.sv"
`include "ctmt/library/Sub_n.sv"
`include "ctmt/library/FA_1bit.sv"
module lsu_new#(parameter n=32,address=12)(op_ls,clk_i,rst_ni,addr_i,st_i,en_st_i,sw_i,ld_o,io_lcd_o,io_ledg_o,io_ledr_o,io_hex_o);
 input logic [3:0] op_ls;
  input logic clk_i;
  input logic rst_ni;
  input logic [address-1:0] addr_i;
  input logic [n-1:0] st_i;
  input logic en_st_i;
  input logic[n-1:0] sw_i;
  output  logic [n-1:0] ld_o;
  output  logic [n-1:0] io_hex_o[0:7];
  output  logic [n-1:0] io_ledr_o;
  output  logic [n-1:0] io_ledg_o;
  output  logic [n-1:0] io_lcd_o;
////////////////////decode//////////////////////////////
	logic[n-1:0] st_o;
	store_ctl#(n) DECODER(st_i,data_mem_o,op_ls,st_o);
/////////////////////dmem//////////////////////////////
	logic[n-1:0] data_mem_o;
	logic[n-1:0] perh_o[0:10];
	logic en_st_o;	
	logic notuse;
	assign notuse=addr_i[0]|addr_i[1];		
	assign en_st_o=((addr_i>>2)==0)?0:1;//
	dmem_new#(n,10) Dmem(~clk_i,rst_ni,addr_i[address-1:2],st_o,en_st_i&en_st_o,data_mem_o,perh_o);
////////////////////switch///////////////
	logic[n-1:0] sw_o;
 	dff_n#(n) SWITCH(sw_i,clk_i|notuse&0,sw_o);
////////////////peripherals output/////////////////////
	always_comb begin: per_out
		for(int i=0;i<8;i++)begin
			 io_hex_o[i] =sw_o&32'hffffff80|perh_o[i]&32'h0000007f;//lay 7 bit 
			end
		io_ledr_o 		=sw_o&32'hfffe0000|perh_o[8]&32'h0001ffff;//lay 17 bit
		io_ledg_o  		=sw_o&32'hffffff00|perh_o[9]&32'h000000ff;//lay 8bit
		io_lcd_o 		=sw_o&32'hfffff800|perh_o[10]&32'h000007ff;// lay 11 bit
	end
///////////////////////load output///////////////////////////////////
	logic[n-1:0] ld_i;
	logic less,eq;
	brcomp#(address-8) compare_1(addr_i[address-1:8],4'b0100,0,clk_i,less,eq);
	assign	ld_i=((less|eq)&en_st_o==1)?data_mem_o:0;
////////////////////encoder//////////////////
	load_ctl#(n) ENCODER(ld_i,op_ls,ld_o);
endmodule:lsu_new
	
		
	
