// problem 1
// a
module mux21_ #(parameter SIZE=1)(input [SIZE-1:0] A, B, input S, output logic [SIZE-1:0] Y);
assign Y = (S) ? A : B;
endmodule

// b
module dreg #(parameter SIZE=1)(input [SIZE-1:0] in, input clk, reset, output logic [SIZE-1:0] Q);
always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		Q <= {SIZE{1'b0}}; 
	else 
		Q <= in;
end
endmodule

// c
module count6 (input clk, reset, output logic [2:0] count);
logic [2:0] new_count;
mux21_ #(3) M1 (3'd0, count+1, count >= 6, new_count);
dreg #(3) D1 (new_count, clk, reset, count);
endmodule

// problem 2
`timescale 1ns/1ps 
module prob2 ();
localparam N=3;
integer fd;

reg clk, reset;
wire [N-1:0] count;
 
count6 C1 (clk, reset, count);
initial begin
	fd = $fopen("fd.txt");
	reset=1'b1; #10;
	reset=1'b0;
	repeat (7) begin
		clk=1'b0; #10; 
		clk=1'b1; #10;
		$fwrite(fd, "count = %b\n", count);
	end
	$fclose(fd);
end

endmodule

// problem 3
module FSM(input x, clk, reset, output logic z); 
// c
localparam S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;
logic [1:0] state, next_state;
// d
always_comb begin
	next_state = S0;
	case (state)
		S0 : next_state = (x) ? S1:S0;
		S1 : next_state = (x) ? S1:S2;
		S2 : next_state = (x) ? S3:S0;
		S3 : next_state = (x) ? S1:S2;
		default : next_state = S0;
	endcase
end
//e
always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		state <= S0;
	else 
		state <= next_state;
end
//f
always_comb begin
	if (state == S3)
		z = 1'b1;
	else 
		z = 1'b0;
end
endmodule

// problem 4
module JKFF(input J, K, clk, reset, output logic Q, Qn);
always_ff @ (posedge clk or posedge reset) begin
	if (reset) 
		Q <= 1'b0;
	else
		Q <= J&~Q | ~K&Q;
end
assign Qn = ~Q;
endmodule

// problem 5
`timescale 1ns/1ps
module JK_tb();

reg J, K, clk, reset;
wire Q, Qn;
JKFF JK1 (J, K, clk, reset, Q, Qn);
initial begin
	reset = 1'b1; J=1'b0; K=1'b0; clk=1'b0; #10; 
	reset = 1'b0; clk=1'b1; #10; // 000
	
	clk=1'b0; J=1'b0; K=1'b1; #10; // 010
	clk=1'b1; #10;
	
	clk=1'b0; J=1'b1; K= 1'b0; #10; // 100
	clk=1'b1; #10;
		
	clk=1'b0; #10; // 101
	clk = 1'b1; #10;
	
	clk=1'b0; J=1'b0; K=1'b0; #10; // 001
	clk=1'b1; #10;

	clk=1'b0; J=1'b0; K=1'b1; #10; // 011
	clk=1'b1; #10;

	clk=1'b0; J=1'b1; K=1'b1; #10; // 110
	clk=1'b1; #10;
	
	clk=1'b0; #10; // 111
	clk=1'b1;
end
endmodule


















