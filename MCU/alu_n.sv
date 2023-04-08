`include "ctmt/library/add_n.sv"
`include "ctmt/library/Sub_n.sv"
//`include "ctmt/library/dff_n.sv"
module alu_n#(parameter n=32) (operand0_i,operand1_i,alu_op_i,clk_i,alu_data_o);
input logic[n-1:0] operand0_i;
input logic[n-1:0] operand1_i;
input logic[3:0] alu_op_i;
input logic clk_i;
output logic[n-1:0] alu_data_o;
//output logic bru_exp_o;
//.....................main.......................//
//data_o
    logic[n-1:0] data_o[0:9];
//add
	logic c_o;
	add_n#(n) Add(operand0_i,operand1_i,clk_i,data_o[0],c_o);
//sll
	assign data_o[1]=operand0_i<<operand1_i[4:0];
//slt
	logic slt_sig,sign;
	logic[n-1:0] data_slt;
	assign sign=(alu_op_i==2)?1:0;
	Sub_n#(n) Slt(sign,operand0_i,operand1_i,clk_i,data_slt,slt_sig);
	assign data_o[2]=(~operand0_i[n-1] &  slt_sig |
					   operand0_i[n-1] & ~operand1_i[n-1]|
					   operand0_i[n-1] &  operand1_i[n-1] & slt_sig  
					 )?1:(data_slt&0);
//sltu
	assign data_o[3]=(slt_sig==1)?1:0;
//xor
	assign data_o[4]=operand0_i^operand1_i;
//srl
	assign data_o[5]=operand0_i>>operand1_i[4:0];
//or	
	assign data_o[6]=operand0_i|operand1_i;
//and
	assign data_o[7]=operand0_i&operand1_i;
//sub
	assign data_o[8]=data_slt;
//sra
	logic[5:0] r,operand1_o;
	logic sig_r;
	assign operand1_o[4:0]=operand1_i[4:0],operand1_o[5]=0;
	Sub_n#(6) Sra(sign|(sig_r | c_o) & 0,n,operand1_o,clk_i,r,sig_r);
	assign data_o[9]= (operand0_i[n-1]==0)?operand0_i>>operand1_i[4:0] : operand0_i>>operand1_i[4:0]|((operand0_i|'1)<<r) ;
//alu_data out
	 always_comb begin: proc	
		case(alu_op_i)
	      4'h0:  alu_data_o = data_o[0];
	      4'h1:  alu_data_o = data_o[1];
	      4'h2:  alu_data_o = data_o[2];
	      4'h3:  alu_data_o = data_o[3];
	      4'h4:  alu_data_o = data_o[4];
	      4'h5:  alu_data_o = data_o[5];
	      4'h6:  alu_data_o = data_o[6];
	      4'h7:  alu_data_o = data_o[7];
	      4'h8:  alu_data_o = data_o[8];
	      4'hd:  alu_data_o = data_o[9];
	      default: 
	        alu_data_o = 0;
	     endcase
//	  bru_exp_o = ((sig_r | c_o) & 0) | (alu_data_o == 0 ? 0 : 1);
	end

endmodule:alu_n
	
		

