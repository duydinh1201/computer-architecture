
module decoder#(parameter n=32) (instr_i,clk_i,rs1_addr_o,rs2_addr_o,rd_addr_o,imm_o,alu_op_o,rd_wr_o,operand_b_sel_o,is_pc_o,is_branch_o,is_jump_o,is_load_o,mem_wr_o);
    input  logic [n-1:0] instr_i;
    input  logic clk_i;
    output logic [4:0] rs1_addr_o;
    output logic [4:0] rs2_addr_o;
    output logic [4:0] rd_addr_o;
    output logic [n-1:0] imm_o;
    output logic [3:0] alu_op_o;
    output logic operand_b_sel_o;
    output logic rd_wr_o;
    output logic is_pc_o;
    output logic is_branch_o;
    output logic is_jump_o;
    output logic is_load_o;
    output logic mem_wr_o;

//...............................main...................................//
logic[4:0] opcode;
	assign opcode  = instr_i[6:2]; //opcode
	assign rs1_addr_o= instr_i[19:15]; //rs1_addr
	assign rs2_addr_o= instr_i[24:20]; //rs2_addr
	assign rd_addr_o = instr_i[11:7];	  //rd_addr
	assign alu_op_o  = {instr_i[30], instr_i[14:12] };//alu_op

// B format
	assign is_branch=(opcode==24)? 1 : 0;
// J format
	assign is_jump  =(opcode==27)? 1 : 0;// JAL
// U format
	logic is_u;
	assign is_u =(opcode==13 || opcode==5)? 1 : 0;	
// I format:cac lenh load,alu voi imm va JALR
	assign is_load  =(opcode==0)?1:0; 	//is_load
//is_pc
	assign is_pc=is_u|is_jump|is_branch;
//mem_wr_o:load,thanh ghi DMEM
    assign mem_wr_o 
	

