`include "ctmt/library/mux2to1_n.sv"
//`include "ctmt/library/dff_n.sv"
module mux4to1_n#(parameter n=4,address=2,m=4)(
	input logic[n-1:0] data_i[0:m-1],
//	input logic clk_i,
	input logic [address-1:0] sel,	
	output logic[n-1:0] data_o
);

//tao index
    logic [address-1:0] sel_reversed;
always_comb begin
    for (int j = 0; j < address; j++) begin
      sel_reversed[j] = sel[address-j-1];
    end
end
logic[n-1:0] data[0:m/2-1][0:1];
  always_comb begin
    for (int i = 0; i < m/2; i++) begin
      for (int j = 0; j < 2; j++) begin
        data[i][j] = data_i[i*2 + j];
      end
    end
  end
//tang 1
	logic[n-1:0] data_i1[0:1];
	    genvar a;
		generate
			for(a=0;a<2;a++) begin
					mux2to1_n#(n) stage1(data[a][0],data[a][1],sel_reversed[1],data_i1[a]);
			end		
		endgenerate
//tang 2
	mux2to1_n#(n) stage2(data_i1[0],data_i1[1],sel_reversed[0],data_o);
 /* //test don't care
 	logic test,test_o;
 	assign test=0;
 	dff_n#(1) Test(test|test_o,clk_i,test_o);*/
 endmodule:mux4to1_n
