module alu (                //dont use <,>,-
	input logic clk_i,
	input logic [31:0]openrand_a_i,
	input logic [31:0]openrand_b_i,
	input logic [3:0]alu_op_i,
	output logic [31:0]alu_data_o
	);
logic [31:0]temp,temp2;
logic carry_o;
logic [1:0]abc;
assign temp = ~openrand_b_i +1;
always_comb begin:proc_alu
	abc = {openrand_a_i[31],openrand_b_i[31]};
	carry_o = 0;
	temp2 = 0;
	case (alu_op_i)
	//0_add
		4'b0000: {carry_o, temp2} = openrand_b_i + openrand_a_i;  		
	//8_sub
		4'b1000: {carry_o, temp2} = openrand_a_i + temp  ; 			   
	//2_stl
		4'b0010: begin case(abc)														    
							2'b00,2'b11: begin {carry_o,temp2} = openrand_a_i + temp ;
											   temp2 = {31'b0,~carry_o};
										 end
							default: temp2[0] = (openrand_a_i[31] & ~openrand_b_i[31]); 
					   endcase
				 end
	//3_stlu
		4'b0011: begin {carry_o,temp2} = openrand_a_i + temp ;
					   temp2 = {31'b0,~carry_o};
				 end  	    
	//4_xor
		4'b0100: temp2 = openrand_a_i ^ openrand_b_i;				
	//6_or
		4'b0110: temp2 = openrand_a_i | openrand_b_i;					
	//7_and
		4'b0111: temp2 = openrand_a_i & openrand_b_i;					
	//1_sll
		4'b0001: temp2 = openrand_a_i << openrand_b_i[4:0];			
	//5_srl
		4'b0101: temp2 = openrand_a_i >> openrand_b_i[4:0];			
	//13_sra
		4'b1101: temp2 = openrand_a_i >>> openrand_b_i[4:0];			
		default: temp2 = 0;
	endcase
end
always @(posedge clk_i)
alu_data_o <= temp2;
endmodule
    
