module store_ctl#(parameter n=32) (data_i,opcode_i,data_o);
input logic[n-1:0] data_i;
input logic[3:0] opcode_i;
output logic[n-1:0] data_o;
////////////////////main//////////////////

	always_comb begin:proc
		case(opcode_i)
			0:     data_o=data_i&32'h000000ff;
			1:     data_o=data_i&32'h0000ffff;
			2:     data_o=data_i;
			default:data_o=0;
		endcase
	end
endmodule:store_ctl
