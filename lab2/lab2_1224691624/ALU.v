module ALU_pv(input [3:0] aluin_a, OPCODE, input Cin, output reg [3:0] alu_out, output reg Cout, output OF);
wire [3:0] aluin_b, alu_out_; wire Cout_, OF_;
assign aluin_b = 4'b0011;
ALU ALU1 (aluin_a, aluin_b, OPCODE, Cin, alu_out_, Cout_, OF);
always @ (*) begin
	alu_out = alu_out_;
	Cout = Cout_;
end
endmodule


module ALU(input [3:0] aluin_a, aluin_b, OPCODE, input Cin, output reg [3:0] alu_out, output reg Cout, output OF);
reg [3:0] Ain, Bin ; reg Cin_;
wire [3:0] Bn, Sum; wire Co;
com2s C1 (aluin_b, Bn);
FA4 FA1 (Ain, Bin, Cin_, Sum, Co, OF);
always @ (*) begin
	Ain = 4'b0000; Bin = 4'b0000; Cin_ = 1'b0; alu_out = 4'b0000; Cout = 1'b0;
	case (OPCODE)
		4'b0001 : begin 
			Ain = aluin_a; Bin = aluin_b; Cin_ = Cin; alu_out = Sum; Cout = Co;
		end
		4'b0010 : begin 
			Ain = aluin_a; Bin = aluin_b; Cin_ = 1'b0; alu_out = Sum; Cout = Co;
		end	
		4'b0011 : begin 
			Ain = aluin_a; Bin = Bn; Cin_ = Cin; alu_out = Sum; Cout = Co;
		end
		4'b0100 : begin 
			alu_out = ~(aluin_a & aluin_b);
		end
		4'b0101 : begin 
			alu_out = aluin_a | aluin_b;
		end
		4'b0110 : begin
			alu_out = aluin_a ^ aluin_b;
		end
		4'b0111 : begin 
			alu_out = ~aluin_a;
		end
		4'b1000 : begin 
			alu_out = aluin_a >> 1;
		end
		default : alu_out = 4'b0000; 
	endcase
end

endmodule

module com2s(input [3:0] B, output [3:0] Bn);
wire [3:0] Bn1; wire OF, Cout;
assign Bn1 = ~B;
FA4 fa1 (Bn1, 4'b0000, 1'b1, Bn, Cout, OF);
endmodule

module FA4(input [3:0] A, B, input Cin, output [3:0] Sum, output Cout, OF);
wire Cout1, Cout2, Cout3;
FA fa1 (A[0], B[0], Cin, Sum[0], Cout1);
FA fa2 (A[1], B[1], Cout1, Sum[1], Cout2);
FA fa3 (A[2], B[2], Cout2, Sum[2], Cout3);
FA fa4 (A[3], B[3], Cout3, Sum[3], Cout);
xor X1 (OF, Cout3, Cout);
endmodule

module FA(input A, B, Cin, output Sum, Cout);
wire Sum1, Cout1, Cout2;
HA ha1 (A, B, Sum1, Cout1);
HA ha2 (Sum1, Cin, Sum, Cout2);
assign Cout = Cout1|Cout2;
endmodule

module HA(input A, B, output Sum, Cout);
assign Sum = A^B;
assign Cout = A&B;
endmodule