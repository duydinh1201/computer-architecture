module soda(
	input logic nickle_i,  //5$
	input logic dime_i,    //10$
	input logic quarter_i, //25$
	output logic soda_o,   //soda=1 if input=20$
	output logic [2:0]change,
	input logic clk_i	
);

logic [2:0]a,temp;
logic [2:0]temp2;
assign a ={quarter_i,dime_i,nickle_i};

always @(posedge clk_i) begin
change <= 0;
soda_o <= 0;  	//reset soda&change after posedge clk
case (temp)
    4,5,6,7: begin //neu luong tien input vuot qua 20$ (gia tri 4) thi output soda va change
      soda_o <= 1;
      change <= temp - 3'b100;
	  temp <= 0;
	  begin
	    case (a)
	      3'b001: temp2 <= temp2 + 3'b001; //5$ tuong duong gia tri 1 
	      3'b010: temp2 <= temp2 + 3'b010; //10$ tuong duong gia tri 2
	      3'b100: temp2 <= temp2 + 3'b101; //25$ tuong duong gia tri 5
	      default: temp2 <= temp2;
	    endcase
	  end
    end
    default: begin
      temp <= temp2;
      case (a)
        3'b001: temp <= temp + 3'b001; //5$ tuong duong gia tri 1 
        3'b010: temp <= temp + 3'b010; //10$ tuong duong gia tri 2
        3'b100: temp <= temp + 3'b101; //25$ tuong duong gia tri 5
        default: temp <= temp;
      endcase
      temp2 <= 0;
    end
  endcase
end
endmodule
    
    
