module top#(parameter n=32)(
	input logic[n-1:0] rs1_d_i,
	input logic[n-1:0] rs2_d_i,
	input logic br_signed, //=0 unsigned
	input logic clk_i,	
	output logic br_less_o,
	output logic br_equal_o
);
brcomp#(n) dut(rs1_d_i,rs2_d_i,br_signed,clk_i,br_less_o,br_equal_o);
endmodule:top 



/*
//soda
module top(
	input logic nickle_i,
	input logic dime_i,
	input logic quater_i,
	input logic clk_i,
	input logic rst_i,
	output logic soda_o,
	output logic[2:0] change_o
);

soda_1  dut(nickle_i,dime_i,quater_i,clk_i,rst_i,soda_o,change_o);
endmodule:top



/*module top#(parameter n=8,address=3,m=8)(Rx_i,ena_wr_i,wr_i,clk_wr_i,clk_rd_i,clk_i,Tx_o,rd_o,round,fl_full_b,rst_start,clk_Sync);
input logic Rx_i,ena_wr_i,clk_i,clk_rd_i,clk_wr_i;
input logic[n-1:0] wr_i;
output logic Tx_o,clk_Sync,rst_start;
output logic [n-1:0] rd_o;
output logic  round;
output logic fl_full_b;


uart#(n,address,m) dut(Rx_i,ena_wr_i,wr_i,clk_wr_i,clk_rd_i,clk_i,Tx_o,rd_o,round,fl_full_b,rst_start,clk_Sync);

endmodule: top
///*
//mining
module top(Rx_i,rst_i,clk_i,Tx_o,fl_end,nonce_o);
input	logic Rx_i,rst_i,clk_i;
output	logic Tx_o,fl_end;
output logic[31:0] nonce_o;
mining dut(Rx_i,rst_i,clk_i,Tx_o,fl_end,nonce_o);
endmodule:top
/*

module top#(parameter n=32,address=4,m=16) (wr_i,ena_wr,clk_wr,ena_rd,clk_rd,rst_i,clk_i,data_o,fl_end,fl_full,clk_Sync);
input logic[n-1:0] wr_i;
input logic rst_i,clk_i,ena_wr,ena_rd;
input logic clk_wr,clk_rd;
output logic fl_end;
output logic[n-1:0]  data_o[0:m-1];
output	logic clk_Sync;
output logic fl_full;
AsynFIFO_n_m#(n,address,m) dut(wr_i,ena_wr,clk_wr,ena_rd,clk_rd,rst_i,clk_i,data_o,fl_end,fl_full,clk_Sync);
endmodule:top
/*
module top#(parameter m=8)(rst_i,clk_i,data_o);
input logic rst_i,clk_i;
output logic[m-1:0] data_o[0:1];
 decoder#(m) dut(rst_i,clk_i,data_o);
 endmodule:top
/*
module top#(parameter n=32) (operand0_i,operand1_i,alu_op_i,clk_i,alu_data_o,bru_exp_o);
input logic[n-1:0] operand0_i,operand1_i;
input logic[3:0] alu_op_i;
input logic clk_i;
output logic[n-1:0] alu_data_o;
output logic bru_exp_o;
 alu_n#(n) dut(operand0_i,operand1_i,alu_op_i,clk_i,alu_data_o,bru_exp_o);
endmodule:top
//*
module top#(parameter n=32) (instr_i,clk_i,rs1_addr_o,rs2_addr_o,rd_addr_o,imm_o,alu_op_o,operand_b_sel_o,operand_a_sel_o,is_B_o,is_J_o,is_load_o,is_U_o,is_I_o,is_S_o,is_R_o);
    input  logic [n-1:0] instr_i;
    input  logic clk_i;
    output logic [4:0] rs1_addr_o;
    output logic [4:0] rs2_addr_o;
    output logic [4:0] rd_addr_o; //dia chi rd
    output logic [n-1:0] imm_o;   //gia tri imm
    output logic [3:0] alu_op_o; //mac dinh lenh add
    output logic operand_b_sel_o; //=0 chon r2
    output logic operand_a_sel_o; //=0 chon r1
    output logic is_B_o;  //=1 neu la B-format
    output logic is_J_o;  //=1 neu la J-format
    output logic is_load_o;//=1 neu la lenh load
    output logic is_U_o;
    output logic is_I_o;
    output logic is_S_o;
    output logic is_R_o;
 decoder#(n)  dut(instr_i,clk_i,rs1_addr_o,rs2_addr_o,rd_addr_o,imm_o,alu_op_o,operand_b_sel_o,operand_a_sel_o,is_B_o,is_J_o,is_load_o,is_U_o,is_I_o,is_S_o,is_R_o);
endmodule:top
/*
module top#(parameter n=32,address=5,m=32) (
	input logic[n-1:0] rd_data_i,
	input logic rd_wr,
	input logic rst_i,
	input logic clk_i,
	input logic[address-1:0] rd_addr_i,
	input logic[address-1:0] rs1_addr_i,
	input logic[address-1:0] rs2_addr_i,
	output logic[n-1:0] rs1_data_o,
	output logic[n-1:0] rs2_data_o
);
regfile#(n,address,m) dut(rd_data_i,rd_wr,rst_i,clk_i,rd_addr_i,rs1_addr_i,rs2_addr_i,rs1_data_o,rs2_data_o);
endmodule:top
*/
