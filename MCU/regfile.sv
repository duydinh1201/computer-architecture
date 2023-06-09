//`include "ctmt/library/dff_n_data.sv"
//`include "ctmt/library/dff_n.sv"
//`include "ctmt/library/mux32to1_n.sv"
module regfile#(parameter n=32,address=5) (
	input logic[n-1:0] rd_data_i,
	input logic rd_wr_i,//=1 is write
	input logic rst_i,
	input logic clk_i,
	input logic[address-1:0] rd_addr_i,
	input logic[address-1:0] rs1_addr_i,
	input logic[address-1:0] rs2_addr_i,
	output logic[n-1:0] rs1_data_o,
	output logic[n-1:0] rs2_data_o
);
//....................main...............//
parameter m=2**address;
//dong bo nho vao
logic[n-1:0] rs_data_o[0:m-1],rs_data_i[0:m-1];
logic[n-1:0]    ena_addr_o;
always_comb begin
    // Assign rs_data_i to rd_data_i for each element
    for (int i = 1; i < m; i++) begin
        rs_data_i[i] = rd_data_i;
    end
    rs_data_i[0]=0;
    // Generate ena_addr_o
    ena_addr_o=0;
    ena_addr_o[rd_addr_i] = 1;
end
    genvar a;
    generate
        for(a=0;a<m;a++) begin
            dff_n_data#(n,0) Reg(rs_data_i[a],rst_i,clk_i&ena_addr_o[a]&rd_wr_i,rs_data_o[a]);
        end
	endgenerate
	mux32to1_n#(m) Rs1(rs_data_o,rs1_addr_i,rs1_data_o);
	mux32to1_n#(m) Rs2(rs_data_o,rs2_addr_i,rs2_data_o);
endmodule:regfile
