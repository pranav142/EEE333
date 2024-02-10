module ALU(input [3:0] aluin_a, aluin_b, OPCODE, input Cin, output reg [3:0] alu_out, output reg Cout, output OF);
endmodule

module com2s(input [3:0] B, output [3:0] Bn);
wire [3:0] Bn1; wire OF;
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