`include "ctmt/library/mux4to1_n.sv"
module mux16to1_n#(parameter n=4,address=4,m=16)(
	input logic[n-1:0] data_i[0:m-1],
	input logic clk_i,
	input logic [address-1:0] sel,	
	output logic[n-1:0] data_o
);

//tao index
 	logic[1:0]	sel_reverse;
always_comb begin
	    for (int j = 0; j < 2; j++) begin
          sel_reverse[j] = sel[1:0][1-j];
	    end
end

logic[n-1:0] data[0:3][0:3];
  always_comb begin
    for (int i = 0; i < 4; i++) begin
      for (int j = 0; j < 4; j++) begin
        data[i][j] = data_i[i*4 + j];
      end
    end
  end

//tang 1
	logic[n-1:0] data_i1[0:3];
	    genvar a;
		generate
			for(a=0;a<4;a++) begin
					mux4to1_n#(n,2,4) stage1(data[a],sel[3:2],data_i1[a]);
			end		
		endgenerate
//tang 2
	mux4to1_n#(n,2,4) stage2(data_i1,sel_reverse[1:0],data_o);
  //test don't care
 	logic test,test_o;
 	assign test=0;
 	dff_n#(1) Test(test|test_o,clk_i,test_o);
 endmodule:mux16to1_n
