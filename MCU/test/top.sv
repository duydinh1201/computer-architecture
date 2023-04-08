module top#(parameter n=32)(io_sw_i,inst_do,io_lcd_o,io_ledg_o,io_ledr_o,io_hex0_o,io_hex1_o,io_hex2_o,io_hex3_o,io_hex4_o,io_hex5_o,io_hex6_o,io_hex7_o,clk_i,rst_ni);
input logic[n-1:0] io_sw_i;
	input logic[n-1:0] inst_do;
output logic [n-1:0] io_lcd_o;
output logic[n-1:0] io_ledg_o;
output logic[n-1:0] io_ledr_o;
output logic[n-1:0] io_hex0_o;
output logic[n-1:0] io_hex1_o;
output logic[n-1:0] io_hex2_o;
output logic[n-1:0] io_hex3_o;
output logic[n-1:0] io_hex4_o;
output logic[n-1:0] io_hex5_o;
output logic[n-1:0] io_hex6_o;
output logic[n-1:0] io_hex7_o;
input logic clk_i;
input logic rst_ni;
single_cycle#(n) dut(io_sw_i,inst_do,io_lcd_o,io_ledg_o,io_ledr_o,io_hex0_o,io_hex1_o,io_hex2_o,io_hex3_o,io_hex4_o,io_hex5_o,io_hex6_o,io_hex7_o,clk_i,rst_ni);
endmodule:top
/*
//lsu
module top#(parameter n=32,address=12)(clk_i,rst_ni,addr_i,st_i,st_en_i,sw_i,ld_o,io_lcd_o,io_ledg_o,io_ledr_o,io_hex_o);
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
lsu#(n,address) dut(clk_i,rst_ni,addr_i,st_i,st_en_i,sw_i,ld_o,io_lcd_o,io_ledg_o,io_ledr_o,io_hex_o);
endmodule:top	 

/*
//dmem
module top#(parameter n=32,address=11)
(
  input logic clk_i,
  input logic rst_ni,
  input logic [address-1:0] addr_i,//lay 12 bit dia chi 
 // input logic [address-1:0] addr_test,//lay 12 bit dia chi 
  input logic [n-1:0] st_data_i,
  input logic st_en_i,
 // input [n-1:0] io_sw_i,
  output  logic [n-1:0] ld_data_o
]);
DMEM#(n,address)  dut(clk_i,rst_ni,addr_i,st_data_i,st_en_i,ld_data_o);
endmodule:top	 

/*
module top#(parameter n=4,address=7,m=128)(
	input logic[n-1:0] data_i[0:m-1],
	input logic clk_i,
	input logic [address-1:0] sel,	
	output logic[n-1:0] data_o
);

mux128to1_n#(n) dut(data_i,clk_i,sel,data_o);
endmodule:top
/*
module top#(parameter n=4,m=4096)(
	input logic[n-1:0] data_i[0:m-1],
	input logic clk_i,
	input logic [11:0] sel,	
	output logic[n-1:0] data_o
);
mux4096to1_n#(n) dut(data_i,clk_i,sel,data_o);
endmodule:top
/*
//regfile
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
/*
//bo so sanh
/*
module top#(parameter n = 31)(
	input logic [n:0]rs1_data_i,
	input logic [n:0]rs2_data_i,
	input logic br_unsigned,
	input logic clk_i,
	output logic br_less,
	output logic br_equal
);
brcomp#(n) dut(rs1_data_i,rs2_data_i,br_unsigned,clk_i,br_less,br_equal);
endmodule:top 
/*
//decoder
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
module top(Rx_i,clk_i,Tx_o,fl_end,nonce_o);
input	logic Rx_i,clk_i;
output	logic Tx_o,fl_end;
output logic[31:0] nonce_o;
mining dut(Rx_i,clk_i,Tx_o,fl_end,nonce_o);
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

*/
