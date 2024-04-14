// 50 percent 
module freq_divider();
endmodule

// case(sel)
// casex(sel) ignores any undefined x or floating bit z
// casez(sel) ignors any bit that is z (we can us e a z or ? to indicate we don't care)
// casez(sel)
//	3'b10?:statementl; // matches either 100 or 101

// unique and priority case
// unique - all items mutually exclusive and unique, if not error
// useful for one hot coding irq cannot match more than one case
module uniquecasez(input [2:0] irq, output logic out1, out2, out3);
always_comb begin
	out1 = 1'b0;
	out2 = 1'b0;
	out3 = 1'b0;
	unique casez (irq)
		3'b1?? : out3 = 1'b1;
		3'b?1? : out2 = 1'b1;
		1'b??1 : out1 = 1'b1;	
	endcase
end
endmodule

// priority
// evaluates all of the cases in order so 100, 110, 101 would trigger out3; think as chained if statement
module prioritycase(input [2:0] irq, output logic out1, out2, out3);
always_comb begin
	out1 = 1'b0;
	out2 = 1'b0;
	out3 = 1'b0;
	priority casez (irq)
		3'b1?? : out3 = 1'b1;
		3'b?1? : out2 = 1'b1;
		3'b??1 : out1 = 1'b1;
		3'b??? : out1 = 1'b1;	
	endcase
end
endmodule

// generate
