module alu (                //dont use <,>,-
	input logic clk_i,
	input logic [31:0]openrand_a_i,
	input logic [31:0]openrand_b_i,
	input logic [3:0]alu_op_i,
	output logic [31:0]alu_data_o,	
	output logic bru_exp_o,
	output logic carry_o
);
logic [31:0]temp,temp2;
logic [1:0]abc;
assign temp = ~openrand_b_i +1;
always_comb begin:proc_alu
	abc = {openrand_a_i[31],openrand_b_i[31]};
	carry_o = 0;
	temp2 = 0;
	case (alu_op_i)
		4'b0000: {carry_o, temp2} = openrand_b_i + openrand_a_i;  		//add
		4'b1000: {carry_o, temp2} = openrand_a_i + temp  ; 			   //sub
		4'b0010: begin case(abc)														    	//stl
							2'b00,2'b11: begin {carry_o,temp2} = openrand_a_i + temp ;
											   temp2 = {31'b0,~carry_o};
										 end
							default: temp2[0] = (openrand_a_i[31] & ~openrand_b_i[31]); //carry = 1 when a=1(negative),b=0(positive)
					   endcase
				 end
		4'b0011: begin {carry_o,temp2} = openrand_a_i + temp ;
					   temp2 = {31'b0,~carry_o};
				 end  	    //sltu
		4'b0100: temp2 = openrand_a_i ^ openrand_b_i;					//xor
		4'b0110: temp2 = openrand_a_i | openrand_b_i;					//or
		4'b0111: temp2 = openrand_a_i & openrand_b_i;					//and
		4'b0001: temp2 = openrand_a_i << openrand_b_i[4:0];			//sll
		4'b0101: temp2 = openrand_a_i >> openrand_b_i[4:0];			//srl
		4'b1101: temp2 = openrand_a_i >>> openrand_b_i[4:0];			//sra
		default: temp2 = 0;
	endcase
end
always @(posedge clk_i) begin
alu_data_o <= temp2;
if (temp2==0) bru_exp_o <=0;
	else bru_exp_o <=1; 
end
endmodule
    
