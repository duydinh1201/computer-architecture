module brcomp #(parameter n = 31)(
	input logic clk_i,
	input logic [n:0]rs1_data_i,
	input logic [n:0]rs2_data_i,
	input logic br_unsigned,
	output logic br_less,
	output logic br_equal
);
logic [n:0]temp;
logic carry;
logic [1:0]abc;

always_comb begin:procmimicro_brcomp
	temp = ~rs2_data_i +1;
	abc = {rs1_data_i[n],rs2_data_i[n]};
	br_equal = 0;
	br_less = 0;
	if (rs1_data_i == rs2_data_i) br_equal = 1;
	else begin
		case (br_unsigned)
		//unsigned
			1: begin {carry,temp} = rs1_data_i + temp;
					br_less = ~carry;
			end
		//signed
			0: begin 
				case (abc)
					2'b00,2'b11: begin
						{carry,temp} = rs1_data_i + temp;
						br_less = ~carry;
						end
					default: br_less = rs1_data_i[n];
				endcase
			end
		endcase
	end
	end
always @(posedge clk_i) begin end
	
endmodule								
