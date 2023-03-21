module decoder#(parameter n=32) (instr_i,clk_i,rs1_addr,rs2_addr,rd_addr,imm,alu_op,rd_wr,operand_b_sel,is_pc,is_branch,is_jump,is_load,mem_wr);
input logic[n-1:0] instr_i;
input logic clk_i;
output logic[4:0] rs1_addr,rs2_addr,rd_addr;
output logic[n-1:0] imm;
output  logic[3:0] alu_op;
output logic operand_b_sel,rd_wr,is_pc,is_branch,is_jump,is_load,mem_wr;

//...............................main...................................//
logic[4:0] opcode;
always_comb begin:dec
	 opcode  = instr_i[6:2]; //opcode
	 rs1_addr= instr_i[19:15]; //rs1_addr
	 rs2_addr= instr_i[24:20]; //rs2_addr
	 rd_addr = instr_i[11:7];	  //rd_addr
	 alu_op  = {instr_i[30], instr_i[14:12] };//alu_op

//is_branch: B format
	 is_branch=(opcode==24)? 1 : 0;
//is jump: J format
	 is_jump  =(opcode==25 || opcode==27)? 1 : 0;
	 is_load  =(opcode==0 )?1:0;
//is_pc:U format
	 is_pc	  =(opcode==13 || opcode==5)? 1 : 0;	
