module traffic_light(
	input logic clk_i,
	input logic button_i,
	output logic green_o,
	output logic amber_o,
	output logic red_o,
	output logic [4:0]time_o
);
always @(posedge clk_i or posedge button_i) begin 
	case (button_i)
		1: begin green_o <= 0; 
				 amber_o <= 0; 
				 red_o <= 1; 
				 time_o <= 5'd9;
		   end
		0: time_o <= time_o+1;
	endcase
	case (time_o)
		0,1,2,3,4,5: begin 
			green_o <= 1; 
			amber_o <= 0; 
			red_o <= 0; 
			end
		6,7: begin 
			green_o <= 0; 
			amber_o <= 1; 
			red_o <= 0; 
			end
		8,9,10,11,12,13,14: begin 
			green_o <= 0; 
			amber_o <= 0; 
			red_o <= 1; 
			end
		15,16: begin 
			green_o <= 0; 
			amber_o <= 1; 
			red_o <= 1; 
			end
		default: begin 
			green_o <= 1; 
			amber_o <= 0; 
			red_o <= 0; 
			time_o <= 1; 
			end
	endcase
end
endmodule
			
