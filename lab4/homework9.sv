module HA(input A, B, output sum, cout); 
assign sum = A^B;
assign cout = A&B;
endmodule

module FA(input A, B, Cin, output sum, cout);
wire s1, c1, c2;
HA ha1 (A, B, s1, c1);
HA ha2 (s1, Cin, sum, c2); 
assign cout = c1 | c2;
endmodule

// problem 1
module FA16 #(parameter width=16) (input [width-1:0] A, B, output logic [width-1:0] C, output logic cout_, OF);
logic [width:0] cout;
assign cout[0]=1'b0;
genvar i;
generate
	begin
		for (i=0;i<width;i=i+1) begin
			FA fa (A[i], B[i], cout[i], C[i], cout[i+1]);
		end
	end
endgenerate
assign cout_ = cout[width];
assign OF = cout[width]^cout[width-1];
endmodule

// problem 2
`timescale 1ns/1ps
module FA16_tb();
logic [15:0] A, B, C;
logic cout, OF;

FA16 FA16_1(A, B, C, cout, OF);

initial begin
A = 16'd5013; B = 16'd2323; #10;
end	
endmodule

// problem 4
module ROM(input [7:0] PC, output logic [15:0] IR );
logic [15:0] mem [20:0];
assign mem[0] = 16'h2000;
assign mem[1] = 16'h2011;
assign mem[2] = 16'h2002;
assign mem[3] = 16'h20A3;
assign mem[4] = 16'hD236;
assign mem[5] = 16'h1014;
assign mem[6] = 16'h4100;
assign mem[7] = 16'h4401;
assign mem[8] = 16'h8022;
assign mem[9] = 16'hE040;
assign mem[10] = 16'h4405;
assign mem[11] = 16'h5536;
assign mem[12] = 16'h6637;
assign mem[13] = 16'h3538;
assign mem[14] = 16'h4329; 
assign mem[15] = 16'h709A;
assign mem[16] = 16'h70AB; 
assign mem[17] = 16'hBB8C; 
assign mem[18] = 16'h9D8E;
assign mem[19] = 16'hC0EF; 
assign mem[20] = 16'hF000; 
assign IR = mem[PC];
endmodule
