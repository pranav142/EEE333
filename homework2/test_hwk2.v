// problem 1 test
`timescale 1ns/1ps
module test_hwk2_1();
reg A, B, C;
wire F, Fs;

homework2_1 hwk21 (F, Fs, A, B, C);

initial begin
	A=0; B=0; C=0; #10; // 000
	C=1; #10; // 001
	B=1; C=0; #10; // 010
	C=1; #10; // 011
	A=1; B=0; C=0; #10; // 100
	C=1; #10; // 101
	B=1; C=0; #10; // 110
	C=1; #10; //111
end
endmodule

// problem 2 test
`timescale 1ns/1ps
module test_hwk2_2();
reg A, B, C, D;
wire F, Fs;

homework2_2 hwk22 (F, Fs, A, B, C, D);

initial begin
	A=0; B=0; C=0; D=0; #10; // 0000
	A=0; B=0; C=0; D=1; #10; // 0001
	A=0; B=0; C=1; D=0; #10; // 0010
	A=0; B=0; C=1; D=1; #10; // 0011
	A=0; B=1; C=0; D=0; #10; // 0100
	A=0; B=1; C=0; D=1; #10; // 0101
	A=0; B=1; C=1; D=0; #10; // 0110
	A=0; B=1; C=1; D=1; #10; // 0111
	A=1; B=0; C=0; D=0; #10; // 1000
	A=1; B=0; C=0; D=1; #10; // 1001
	A=1; B=0; C=1; D=0; #10; // 1010
	A=1; B=0; C=1; D=1; #10; // 1011
	A=1; B=1; C=0; D=0; #10; // 1100
	A=1; B=1; C=0; D=1; #10; // 1101
	A=1; B=1; C=1; D=0; #10; // 1110
	A=1; B=1; C=1; D=1; #10; // 1111
end
endmodule