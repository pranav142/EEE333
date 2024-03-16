// try to implement parameters whenever you can

// creating muxes 4:1
// 2:1
module MUX21 #(parameter SIZE=3) (input [SIZE-1:0] A, B, input Sel, output logic [SIZE-1:0] Out);
assign Out = (Sel)? A : B;
endmodule

module MUX41 #(parameter SIZE=3) (input [SIZE-1:0] A, B, C, D, input [1:0] Sel, output logic [SIZE-1:0] Out);
always_comb begin
	Out = {SIZE{1'b0}};
	case (Sel)
		2'b00 : Out = A;
		2'b01 : Out = B;
		2'b10 : Out = C;
		2'b11 : Out = D;
		default : Out = {SIZE{1'bx}};
	endcase
end
endmodule

// DReg
module Dreg #(parameter SIZE=3) (input [SIZE-1:0] D, input clk, reset, output logic [SIZE-1:0] Q, Qn);
always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		Q <= {SIZE{1'b0}};
	else
		Q <= D;
end
assign Qn = ~Q;
endmodule

// flipflops
module JK(input J, K, clk, output logic Q, Qn);
always_ff @ (posedge clk) begin
	Q <= J&~Q | ~K&Q;
end
assign Qn = ~Q;
endmodule

// FSM 	
	// mealy
		// always block
		// Mux + Dreg

// moore
// always block
module FSM_moore_a(input clk, reset, x, output logic [1:0] state, output logic Z);
localparam S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;
logic [1:0] next_state;

always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		state <= S0;
	else
		state <= next_state;
end

always_comb begin
	next_state = S0;
	case (state)
		S0: next_state = (x) ? S1:S0;
		S1: next_state = (x) ? S1:S2;
		S2: next_state = (x) ? S3:S0;
		S3: next_state = S3;
		default: next_state = S0;
	endcase	
end

always_comb begin
	if (state == S3) 
		Z = 1'b1;
	else
		Z = 1'b0;
end
endmodule

// moore
// Mux + Dreg
module FSM_moore(input clk, reset, x, output logic[1:0] state, output logic Z);
localparam S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;
logic [1:0] next_state;
logic Qn;
// determine state 
MUX41 #(2) M1 ((x)?S1:S0,(x)?S1:S2 , (x)?S3:S0 , S3 , state, next_state);
Dreg #(2) D1 (next_state, clk, reset, state, Qn);

// determine output
MUX41 #(1) M2 (1'b0, 1'b0, 1'b0, 1'b1, state, Z);
endmodule

// Counter
// Mux + Dreg
module counter6 #(parameter SIZE=3) (input clk, reset, input [SIZE-1:0] maxval, output logic [SIZE-1:0] Count);
logic [SIZE-1:0] NextCount, Count_, Qn;
logic rst;
assign NextCount = Count + {{SIZE-1{1'b0}},1'b1};
assign rst = (Count > maxval) ? 1'b1 : 1'b0;
MUX21 #(SIZE) M1 ({SIZE{1'b0}}, NextCount, reset|rst, Count_);
Dreg #(SIZE) D1 (Count_, clk, reset|rst, Count, Qn);
endmodule

// always block
module counter6_a #(parameter SIZE=3) (input clk, reset, input [SIZE-1:0] maxval, output logic [SIZE-1:0] Count);
always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		Count <= {SIZE{1'b0}};
	else if (Count == maxval)
		Count <= {SIZE{1'b0}};
	else
		Count <= Count + {{SIZE-1{1'b0}}, 1'b1};
end
endmodule

// Test Benches

// functions

// flip flops TB

// counters TB
`timescale 1ns/1ps
module prob2();
localparam N = 3;
logic clk, reset;
integer fd;
logic [N-1:0] Count, maxval;
assign maxval = 3'd6;
counter6 #(N) C1 (clk, reset, maxval, Count);
initial begin
	fd = $fopen("test.txt");
	reset=1'b1; clk=1'b0; #5;
	reset=1'b0; clk=1'b0; #5;
	repeat (9) begin
		clk = 1'b0; #5;
		clk = 1'b1; #5
		$fwrite(fd, "Count = %b", Count);
	end
	$fclose(fd);
end
endmodule

module mux21 #(parameter SIZE=3) (input [SIZE-1:0] A, B, input sel, output logic Y); 
assign Y = (sel) ? A:B;
endmodule

module regstr #(parameter SIZE=3) (input [SIZE-1:0] D, input clk, reset, output logic [SIZE-1:0] Q, Qn);
always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		Q <= {SIZE{1'b0}};
	else 
		Q <= D;
end
assign Qn = ~Q;
endmodule

module JK_FF(input J, K, clk, output logic Q, Qn);
always_ff @ (posedge clk) begin
	Q <= J&~Q | ~K&Q;
end
assign Qn = ~Q;
endmodule

module SR_FF(input S, R, clk, output logic Q, Qn);
always_ff @ (posedge clk) begin
	Q <= S | ~R&Q;
end
assign Qn = ~Q;
endmodule

// count to 6 and reset
module count #(parameter SIZE=3) (input clk, reset, input [SIZE-1:0] maxcount, output logic [SIZE-1:0] count);
logic [SIZE-1:0] Qn;
regstr #(SIZE) R1 ((count == maxcount) ? {SIZE{1'b0}} : (count + {{SIZE-1{1'b0}}, 1'b1}), clk, reset, count, Qn);
endmodule

module counta #(parameter SIZE=3) (input clk, reset, input [SIZE-1:0] maxcount, output logic [SIZE-1:0] count);
always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		count <= {SIZE{1'b0}};
	else if (count == maxcount)
		count <= {SIZE{1'b0}};
	else 
		count <= count + {{SIZE-1{1'b0}}, 1'b1};
end
endmodule

`timescale 1ns/1ps
module count_tb();
localparam N=3;
integer fd;

logic clk, reset;
logic [N-1:0] maxcount, count;
assign maxcount = 3'd6;
count #(N) C1 (clk, reset, maxcount, count);

initial begin
fd = $fopen("test.txt");
clk= 1'b0; reset=1'b1; #5; 
clk= 1'b1; reset=1'b0; #5;
repeat(9) begin
	clk=1'b0; #5;
	clk=1'b1; #5;
	$fwrite(fd, "count = %b", count);
end
$fclose(fd);
end

endmodule

module mux41 #(parameter SIZE=3) (input [SIZE-1:0] A, B, C, D, input [1:0] sel, output logic [SIZE-1:0] Y);
always_comb begin
	Y = A;
	unique case (sel)
		2'b00 : Y = A;
		2'b01 : Y = B;
		2'b10 : Y = C;
		2'b11 : Y = D;
	endcase
end
endmodule

module moore(input x, clk, reset, output logic [1:0] state, output logic z);
localparam S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;
logic [1:0] next_state;
always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		state <= S0;
	else 
		state <= next_state;
end	

always_comb begin
	next_state = S0;
	case (state)
		S0 : next_state = (x) ? S1 : S0;
		S1 : next_state = (x) ? S1 : S2;
		S2 : next_state = (x) ? S3 : S0;
		S3 : next_state = (x) ? S1 : S2;
		default next_state = S0;
	endcase
end

always_comb begin
	if (state == S3)
		z = 1'b1;
	else 
		z = 1'b0;
end	
endmodule

module moore2(input x, clk, reset, output logic [1:0] state, output logic z);
localparam S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;
logic [1:0] next_state, Qn; 
mux41 #(2) M1 ((x) ? S1: S0, (x) ? S1 : S2, (x) ? S3 : S0, (x) ? S1 : S2, state, next_state);
regstr #(2) R1 (next_state, clk, reset, state, Qn);

mux41 #(1) M2 (1'b0, 1'b0, 1'b0, 1'b1, state, z);
endmodule


