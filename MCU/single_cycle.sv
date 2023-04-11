`include "ctmt/library/dff_n.sv"
`include "ctmt/library/dff_n_data.sv"
`include "ctmt/library/mux128to1_n.sv"
`include "ctmt/MCU/lsu_new.sv"
`include "ctmt/MCU/dmem_new.sv"
`include "ctmt/MCU/alu_n.sv"
`include "ctmt/MCU/branch_condition.sv"
`include "ctmt/MCU/brcomp.sv"
`include "ctmt/MCU/decoder.sv"
`include "ctmt/MCU/regfile.sv"
`include "ctmt/MCU/load_ctl.sv"
`include "ctmt/MCU/store_ctl.sv"
//`include "lab_comparch/singlecycle-test/memory/inst_memory.sv"
module single_cycle#(parameter n=32)
(	
	input logic[n-1:0] io_sw_i,
	input logic[n-1:0] inst_i,
	output logic [n-1:0] io_lcd_o,
	output logic[n-1:0] io_ledg_o,
	output logic[n-1:0] io_ledr_o,
	output logic[n-1:0] io_hex0_o,
	output logic[n-1:0] io_hex1_o,
	output logic[n-1:0] io_hex2_o,
	output logic[n-1:0] io_hex3_o,
	output logic[n-1:0] io_hex4_o,
	output logic[n-1:0] io_hex5_o,
	output logic[n-1:0] io_hex6_o,
	output logic[n-1:0] io_hex7_o,
	input logic clk_i,
	input logic rst_ni
);
////////////////////////////main//////////////////////////////
//parameter n_addr=14;//so bit dia chi cua instr
parameter n_reg=5;//so bit dia chi regfile
parameter n_lsu=12;//so bit dia chi lsu
//PC
	//jal,jalr,br
	logic[n-1:0] pc_in,pc_o;
	logic[n-1:0] inst_do;
	assign pc_in=((en_jump_br | jalr | J_fmt)==1 )? alu_data_o : (pc_o+4);
	dff_n_data#(n,0) PC(pc_in,rst_ni,clk_i,pc_o);
	dff_n_data#(n,0) INTRUCT(inst_i,rst_ni,clk_i,inst_do);
/*
//IMEM
	logic[n-1:0] inst_do;
	inst_memory#(n_addr) INST(pc_o[n_addr-1:0],inst_do,clk_i,rst_ni);*/
/////////////////DECODER////////////////////////
	logic	operand_b_sel_o,B_fmt,J_fmt,is_load,LUI,APIPC,jalr,S_fmt;
	logic[3:0] alu_op_o;
	logic[n-1:0] imm_o;
	logic[n_reg-1:0] rs1_addr_o,rs2_addr_o,rd_addr_o;
	decoder#(n) DECODER(
			inst_do,rs1_addr_o,rs2_addr_o,rd_addr_o,imm_o,alu_op_o,
			operand_b_sel_o,B_fmt,J_fmt,is_load,LUI,APIPC,jalr,S_fmt
			);

//////////////////REGFILE///////////////////////	
	//is_load,jalr
	logic[n-1:0] rs1_d_reg,rs2_d_reg,rd_d_i;
	logic en_wr_reg;
	////////////////////////////
	assign rd_d_i=(is_load==1)? ld_lsu_o : ((jalr|J_fmt)==1)? (pc_o+4) : (LUI==1)? imm_o : alu_data_o;
	assign en_wr_reg=~(B_fmt|S_fmt);//cho phep ghi khi khong phai B_fmt va S_fmt
	///////////////////////////
	regfile#(n,n_reg) REGFILE(
			rd_d_i,en_wr_reg,rst_ni,~clk_i,rd_addr_o,
			rs1_addr_o,rs2_addr_o,rs1_d_reg,rs2_d_reg
		);
///////////////////BRANCH/////////////////////
	logic en_jump_br;	
	branch_condition#(n) ENA_JUMP_BR(
		B_fmt,rs1_d_reg,rs2_d_reg,alu_op_o[2:0],clk_i,en_jump_br
	);
////////////////////ALU///////////////////////
	logic[n-1:0] alu_d2,alu_d1,alu_data_o;
	//ALU condition
	assign alu_d1=((en_jump_br | J_fmt | APIPC)==1)? pc_o : rs1_d_reg;
	assign alu_d2=(operand_b_sel_o==0)? rs2_d_reg : imm_o;
	///////////////////////
	alu_n#(n) ALU(
		alu_d1,alu_d2,((B_fmt|is_load|S_fmt)==1)?0:alu_op_o,clk_i,alu_data_o
	);
////////////////////LSU////////////////////////////
	logic[n_lsu-1:0] addr_lsu;
	logic[n-1:0]  st_lsu,ld_lsu_o,io_hex_o[0:7];
	logic en_st;
	////////////////////
	assign st_lsu=rs2_d_reg;
	assign en_st=S_fmt;					 
	assign addr_lsu=alu_data_o[n_lsu-1:0];//=rs1+imm
	/////////////////////	
	lsu_new#(n,n_lsu)  LSU(
		alu_op_o,clk_i,rst_ni,addr_lsu,st_lsu,en_st,io_sw_i,ld_lsu_o,io_lcd_o,io_ledg_o,io_ledr_o,io_hex_o
	);
	assign io_hex7_o=io_hex_o[7];
	assign io_hex6_o=io_hex_o[6];
	assign io_hex5_o=io_hex_o[5];
	assign io_hex4_o=io_hex_o[4];
	assign io_hex3_o=io_hex_o[3];
	assign io_hex2_o=io_hex_o[2];
	assign io_hex1_o=io_hex_o[1];
	assign io_hex0_o=io_hex_o[0];
endmodule:single_cycle
	
