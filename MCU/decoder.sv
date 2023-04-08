//`include "ctmt/library/dff_n.sv"

module decoder#(parameter n=32) (instr_i,rs1_addr_o,rs2_addr_o,rd_addr_o,imm_o,alu_op_o,operand_b_sel_o,is_B_o,is_J_o,is_load_o,is_LUI_o,is_AUIPC_o,is_JALR_o,is_S_o);
    input  logic [n-1:0] instr_i;
//    input  logic clk_i;
    output logic [4:0] rs1_addr_o;//dia chi rs1
    output logic [4:0] rs2_addr_o;//dia chi rs2
    output logic [4:0] rd_addr_o; //dia chi rd
    output logic [n-1:0] imm_o;   //gia tri imm
    output logic [3:0] alu_op_o; //mac dinh lenh add
    output logic operand_b_sel_o; //=0 chon r2
  //  output logic operand_a_sel_o; //=0 chon r1
    output logic is_B_o;  //=1 neu la B-format
    output logic is_J_o;  //=1 neu la J-format
    output logic is_load_o;//=1 neu la lenh load
    output logic is_LUI_o;//=1 neu la U-format
    output logic is_AUIPC_o;//=1 neu la U-format
    output logic is_JALR_o;//=1 neu la U-format
  //  output logic is_I_o;//=1 neu la I-format
    output logic is_S_o;//=1 neu la S-format
 //   output logic is_R_o;//=1 neu la R-format

//...............................main...................................//
//address
always_comb begin:address
	       rs1_addr_o= instr_i[19:15]; //rs1_addr
		   rs2_addr_o= instr_i[24:20]; //rs2_addr
		   rd_addr_o = instr_i[11:7];	  //rd_addr
 	end
//opcode	
logic[4:0] opcode;
logic is_U_o,is_R_o,is_I_o;
assign is_U_o= is_LUI_o|is_AUIPC_o;
always_comb begin:Opcode
	 opcode    = instr_i[6:2]; //opcode
 	 is_I_o    =(opcode==25||//jalr
 	 			 opcode==4 || //imm
 	 			 opcode==0  //load
 	 			 )?1:0;
 	 is_JALR_o  =(opcode==25)?1:0;
 	 is_B_o	   =(opcode==24)?1:0;
 	 is_LUI_o	   =(opcode==13)?1:0;
 	 is_AUIPC_o	   =(opcode==5)?1:0;
	 is_S_o	   =(opcode==8)?1:0;
     is_J_o	   =(opcode==27)?1:0;
	 is_R_o	   =(opcode==12)?1:0;
   end
//imm
	logic[n-1:0] imm_J,imm_B,imm_I,imm_S;
	assign imm_J={12'b0,instr_i[19:12],instr_i[20],instr_i[30:21],1'b0};
	assign imm_B={20'b0,instr_i[7],instr_i[30:25],instr_i[11:8],1'b0};
	assign imm_I={20'b0,instr_i[31:20]};
	assign imm_S={20'b0,instr_i[31:25],rd_addr_o};
always_comb begin:Imm
	if(is_U_o) 	        imm_o=instr_i&32'hfffff000;
	else if(is_J_o) 	imm_o=(instr_i[n-1])?imm_J|32'hfff00000:imm_J;
	else if(is_I_o) 	imm_o=(instr_i[n-1])?imm_I|32'hfffff000:imm_I;
	else if(is_B_o)	    imm_o=(instr_i[n-1])?imm_B|32'hfffff000:imm_B;
	else if(is_S_o)	    imm_o=(instr_i[n-1])?imm_S|32'hfffff000:imm_S;
	else imm_o=0;
end
//alu_op
	logic[3:0] alu_op;
	logic I_imm;
always_comb begin:Alu_op
	 I_imm  = (is_I_o && ((instr_i[14:12] == 1) || (instr_i[14:12] == 5))) ? 1'b1 : 1'b0;//==0,I-format co dung gia tri imm	
	 alu_op = {instr_i[30], instr_i[14:12]}; // ALU operation
	 alu_op_o = (is_J_o|is_U_o|(opcode==25)?1:0)?0:(is_R_o|I_imm) ? alu_op : (alu_op & 4'b0111);	
	end
//operand_b_sel_o
	assign   is_load_o=(opcode==0)?1:0;
	assign  operand_b_sel_o=~(is_S_o|is_B_o|is_R_o|I_imm);//=0 chon rs2,=1 chon imm
/*
//operand_a_sel_o
	assign	operand_a_sel_o=is_U_o|is_J_o;//=0 chon rs1,=1 chon imm

/*
//test:don't care
	logic I_imm_o;
	dff_n#(1) i_imm_o(I_imm|I_imm_o,clk_i,I_imm_o);*/
endmodule:decoder	 
 	 			 
				

	

