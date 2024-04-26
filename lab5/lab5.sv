module mux41 #(parameter size=4)(input [size-1:0] A, B, C, D, input [1:0] sel, output logic [size-1:0] Y);
always_comb begin
	Y = {size{1'b0}};
	case (sel)
		2'b00 : Y = A;
		2'b01 : Y = B;
		2'b10 : Y = C;	
		2'b11 : Y = D;
		default : Y = {size{1'bx}};
	endcase
end
endmodule

module alu();

endmodule
