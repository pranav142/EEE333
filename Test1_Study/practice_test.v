// JK Flip Flop
module jk(input J, K, Clk, Reset, En, output reg Q, output Qn);
always @ (posedge Clk or posedge Reset) begin
	if (Reset)
		Q <= 1'b0;
	else if (En)	
		Q <= J&~K | K&~Q;
end	
assign Qn = ~Q;
endmodule
// SR Flop Flop
module sr(input S, R, Clk, Reset, En, output reg Q, output Qn);
always @ (posedge Clk or posedge Reset) begin 
	if (Reset)
		Q <= 1'b0;
	else if (S&&R)
		Q <= 1'bx;
	else if (En)
		Q <= S | R&~Q;
end	
assign Qn = ~Q;
endmodule
// T Flop FLop
module t(input T, Clk, Reset, En, output reg Q, output Qn);
always @(posedge Clk or posedge Reset) begin
	if (Reset)
		Q <= 1'b0;
	else if (En)
		Q <= T^Q;
end
assign Qn = ~Q;
endmodule
// D Flop Flop
module d(input D, Clk, Reset, En, output reg Q, output Qn);
always @ (posedge Clk or posedge Reset) begin
	if (Reset)
		Q <= 1'b0;
	else if (En)
		Q <= D;
end
assign Qn = ~Q;
endmodule

// 4-1 Mux Procedural
module mux41_(input [3:0] A, B, C, D, input [1:0] S, output reg [3:0] Y);
always @ (*) begin
	Y = 4'b0000;
	case (S)
		2'b00:Y=A;
		2'b01:Y=B;
		2'b10:Y=C;
		2'b11:Y=D;
		default:Y=4'bxxxx;
	endcase
end
endmodule

// 2-1 Mux Ternary
module mux21_(input A, B, S, output Y);
assign Y = (S) ? B : A;
endmodule


// Half Adder
module HA(input A, B, output sum, cout); 
assign sum = A^B;
assign cout = A&B;
endmodule

// Full Adder
module FA(input A, B, Cin, output sum, cout);
wire s1, c1, c2;
HA ha1 (A, B, s1, c1);
HA ha2 (s1, Cin, sum, c2); 
assign cout = c1 | c2;
endmodule
// Ripple Adder
module FA4(input [3:0] A, B, input Cin, output [3:0] sum, output cout, OF);
wire co1, co2, co3;
FA FA1 (A[0], B[0], Cin, sum[0], co1);
FA FA2 (A[1], B[1], co1, sum[1], co2);
FA FA3 (A[2], B[2], co2, sum[2], co3);
FA FA4 (A[3], B[3], co3, sum[3], cout);
assign OF = cout ^ co3;
endmodule
// ALU (Add, Sub, Mult, Div)
module ALU(input [3:0] A, B, input [1:0] OPCODE, output [3:0] sum);
wire [3:0] Add, Sub, Mult, Div, Comb;
FA4 FA41 (A, B, 1'b0, Add, co1, OF_);
FA4 FA42 (~B, 4'b0000, 1'b1, Comb, co2, OF2_);
FA4 FA43 (A, Comb, 1'b0, Sub, co3, OF3_);
assign Mult = A * B;
assign Div = A / B;
mux41 mx (Add, Sub, Mult, Div, OPCODE, sum);
endmodule

module ALU2(input [3:0] A, B, input [1:0] OPCODE, input cin, output reg[3:0] sum, output reg cout, output OF);
reg [3:0] A_, B_; reg cin_;
wire [3:0] sum_, cout_, Bn;
FA4 FA41 (B, 4'b0000, 1'b1, Bn, cout2_, OF2);
FA4 FA42 (A_, B_, cin_, sum_, cout_, OF);
always @ (*) begin
	sum = 4'b0000; cout = 1'b0; A_=4'b0000; B_=4'b0000; cin_=1'b0;
	case (OPCODE)
		2'b00: begin
			A_=A; B_=B; cin_=cin; sum=sum_; cout=cout_;
		end
		2'b01: begin
			A_= A; B_=Bn; cin_=1'b0; sum=sum_; cout=cout_;
		end
		2'b10: begin
			A_=4'b0000; B_=4'b0000; cin_=1'b0; sum=A*B; cout=1'b0;
		end
		2'b11 : begin
			A_=4'b0000; B_=4'b0000; cin_=1'b0; sum=A/B; cout=1'b0;
		end
	endcase
end
endmodule
// Test Bench for

// hald adder
`timescale 1ns/1ps
module HA_TB();
reg A, B;
wire Sum, Cout;
HA HA1 (A, B, Sum, Cout);
initial begin
A =1'b0; B=1'b0; #10;
A =1'b0; B=1'b1; #10;
A =1'b1; B=1'b0; #10;
A =1'b1; B=1'b1; #10;
end
endmodule
// full adder

`timescale 1ns/1ps
module FA_TB();
reg A, B, Cin;
wire Sum, Cout;

FA FA1 (A, B, Cin, Sum, Cout);
initial begin
A=1'b0; B=1'b0; Cin=1'b0; #10;
A=1'b0; B=1'b0; Cin=1'b1; #10;
A=1'b0; B=1'b1; Cin=1'b0; #10;
A=1'b0; B=1'b1; Cin=1'b1; #10;
A=1'b1; B=1'b0; Cin=1'b0; #10;
A=1'b1; B=1'b0; Cin=1'b1; #10;
A=1'b1; B=1'b1; Cin=1'b0; #10;
A=1'b1; B=1'b1; Cin=1'b1; #10;
end
endmodule 
// ripple adder

`timescale 1ns/1ps
module FA4_TB();
reg [3:0]A, B; reg Cin;
wire [3:0] sum; wire cout, OF;
FA4 FA1 (A, B, Cin, sum, cout, OF);
initial begin
A=4'b0000; B=4'b0000; Cin=1'b0; #10;
A=4'b1111; B=4'b1111; Cin=1'b1; #10;
A=4'b0011; B=4'b1100; Cin=1'b0; #10;
end
endmodule

// alu