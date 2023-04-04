module dec12to4096_n#(parameter n=12)(
	input logic[n-1:0] sel_i,
	output logic data_o[0:2**n-1]
)
always_comb begin
	data_o=0;
	data_o[sel_i]=1;
  end
endmodule :dec12to4096_n
