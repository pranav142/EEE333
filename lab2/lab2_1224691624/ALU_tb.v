`timescale 1ns/1ps
module ALU_tb();
reg [0:3] A, B, OPCODE, T1; reg Cin;
wire [0:3] Sum; wire Cout, OF;

ALU ALU1 (A, B, OPCODE, Cin, Sum, Cout, OF);

initial begin
A=4'b0011; B=4'b0011; Cin=1'b0; OPCODE=4'b0001; #10;
A=4'b0110; B=4'b0101; Cin=1'b1; OPCODE=4'b0010; #10;
A=4'b0111; B=4'b0110; Cin=1'b0; OPCODE=4'b0011; #10;
A=4'b0111; B=4'b1010; Cin=1'b0; OPCODE=4'b0100; #10;
A=4'b0111; B=4'b0011; Cin=1'b0; OPCODE=4'b0101; #10;
A=4'b0101; B=4'b1110; Cin=1'b0; OPCODE=4'b0110; #10;
A=4'b1011; B=4'b0000; Cin=1'b0; OPCODE=4'b0111; #10;
A=4'b0101; B=4'b0011; Cin=1'b0; OPCODE=4'b1000; #10;

// Number 9
A=4'b0100; B=4'b0011; Cin=1'b0; OPCODE=4'b0110; #10; // Logicl XOR For T1
T1=Sum;
A=4'b0100; B=4'b0011; Cin=1'b0; OPCODE=4'b0100; #10; // Logical NAND
A=Sum; OPCODE=4'b0111; #10; // logical NOT of NAND to gen AND
A=Sum; OPCODE=4'b1000; #10;
A=T1; B=Sum; OPCODE=4'b0010; #10;
end

endmodule


