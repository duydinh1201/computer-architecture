`include "ctmt/library/mux128to1_n.sv"
module mux512to1_n#(parameter n=4,address=9,m=512)(
	input logic[n-1:0] data_i[0:m-1],
//	input logic clk_i,
	input logic [address-1:0] sel,	
	output logic[n-1:0] data_o
);
logic[n-1:0] data_odd_1[0:m/2-1],data_even_1[0:m/2-1];
logic[n-1:0] data_odd_1a[0:1][0:m/4-1],data_even_1a[0:1][0:m/4-1];
logic[n-1:0] data_odd_2[0:m/8-1],data_even_2[0:m/8-1];
  always_comb begin
  	for(int i=0;i<m/2;i++) begin
	  	data_odd_1[i]=data_i[2*i+1];
	  	data_even_1[i]=data_i[2*i];
  	end
  	for(int i=0;i<m/4;i++) begin
	  	data_odd_1a[1][i]=data_odd_1[2*i+1];
	  	data_even_1a[1][i]=data_odd_1[2*i];
  	end
  	for(int i=0;i<m/4;i++) begin
	  	data_odd_1a[0][i]=data_even_1[2*i+1];
	  	data_even_1a[0][i]=data_even_1[2*i];
  	end
  	for(int i=0;i<4;i++) begin
	  	data_odd_2[i]=data_i1[2*i+1];
	  	data_even_2[i]=data_i1[2*i];
  	end
  end 
//tang dau
	logic[n-1:0]	data_i1[0:3];
	mux128to1_n#(n) stage_1a(data_even_1a[0],sel[address-1:2],data_i1[0]);
	mux128to1_n#(n) stage_1b(data_odd_1a[0],sel[address-1:2],data_i1[1]);
	mux128to1_n#(n) stage_1c(data_even_1a[1],sel[address-1:2],data_i1[2]);
	mux128to1_n#(n) stage_1d(data_odd_1a[1],sel[address-1:2],data_i1[3]);
//tang sau
    logic[n-1:0]	data_i2[0:3];
    assign data_i2[0:1]=data_even_2[0:1];
    assign data_i2[2:3]=data_odd_2[0:1];
	mux4to1_n#(n) stage_2(data_i2,sel[1:0],data_o);
/*
//test don't care
	logic test,test_o;
 	assign test=0;
 	dff_n#(1) Test(test|test_o,clk_i,test_o);*/
endmodule:mux512to1_n
