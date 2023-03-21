`include "src/library/Sub_n.sv"
module compare_n#(parameter n=8,sign=0)(data0_i,data1_i,clk_i,sig_o);
input logic [n-1:0] data0_i,data1_i;
input logic clk_i;
output logic [1:0] sig_o; 
logic [n-1:0] data_o;
logic over;
//thuc hien phep tru
	Sub_n#(n,sign) sub(data0_i,data1_i,clk_i,data_o,over);
//so sanh
	always_comb begin:proc
		if(data_o==0) sig_o=2'b00;
		else if (over^sign) sig_o=2'b01;
		else sig_o=2'b10;
	end
endmodule:compare_n
