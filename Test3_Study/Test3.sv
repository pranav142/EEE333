// behavioral versus structural

// EXAM 1 Review
// SR Flip Flop
module SR_FF(input clk, reset, S, R, output logic Q, Qn);
always_ff @ (posedge clk or posedge reset) begin
	if (reset)	
		Q <=1'b0;
	else 
		Q <= S | ~R&Q;
end
assign Qn = ~Q;
endmodule
// JK Flip FLop
module JK_FF (input clk, reset, J, K, output logic Q, Qn);
always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		Q <= 1'b0;
	else
		Q <= J&~K |K&~Q;
end
assign Qn = ~Q;
endmodule

// Mux 21
module mux21_ #(parameter size=4)(input [size-1:0] A, B, input S, output logic [size-1:0] Y);
assign Y = (S) ? A : B;
endmodule	

// half adder
module HA(input A, B, output logic sum, cout);
assign sum = A^B;
assign cout = A&B;
endmodule

// full adder (using HA) 
module FA(input A, B, Cin, output logic sum, cout);
logic s1, c1, s2;
HA ha1 (A, B, s1, c1);
HA ha2 (s1, Cin, sum, c2);
assign cout = c1 | c2;
endmodule
// full adder with just logic
module FA2(input A, B, Cin, output logic sum, cout);
assign S = A^B^Cin;
assign Cout = A&B|A&Cin|B&Cin;
endmodule
// ripple adder
module RA(input [3:0] A, B, input Cin, output logic [3:0] sum, output logic cout, OF);
logic c1, c2, c3, c4;
FA FA1 (A[0], B[0], Cin, sum[0], c1);
FA FA2 (A[1], B[1], c1, sum[1], c2);
FA FA3 (A[2], B[2], c2, sum[2], c3);
FA FA4 (A[3], B[3], c3, sum[3], cout);
assign OF = c3 ^ cout;
endmodule

// EXAM 2
// DReg
module register #(parameter size=4)(input [size-1:0] D, input clk, reset, output logic [size-1:0] Q, Qn);
always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		Q <= {size{1'b0}};
	else 
		Q <= D;
end
assign Qn = ~Q;
endmodule

module Dreg2 #(parameter N=3) (input clk, reset, input [N-1:0] D, resetval, output logic [N-1:0] Q);
always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		Q <= resetval;
	else
		Q <= D;
end

endmodule
// FSM Using Always
module FSM(input clk, reset, x, output logic [1:0] Z, output logic [1:0] state);
localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
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
		S0 : begin
			next_state = (x) ? S0 : S1; 
			Z = (x) ? 2'b10 : 2'b00;
		end	
		S1 : begin
			next_state = (x) ? S2 : S1;
			Z = (x) ? 2'b01 : 2'b10;
		end
		S2 : begin
			next_state = (x) ? S0 : S3;
			Z = (x) ? 2'b10 : 2'b01;
		end
		S3 : begin
			next_state = (x) ? S2 : S1;	
			Z = (x) ? 2'b00 : 2'b11;
		end
	endcase
end
endmodule
// FSM One Hot encoded + unique casez using D reg and muxm
module FSM2(input clk, reset, x, output logic [1:0] Z, output logic [3:0] state);
localparam S0=4'b0001, S1=4'b0010, S2=4'b0100, S3=4'b1000;
logic [3:0] next_state;
Dreg2 #(4) D1 (clk, reset, next_state, S0, state);

always_comb begin
	Z = 2'b00;	
	state = S0;
	unique casez (state)
		S0 : begin
			next_state = (x) ? S1:S0;
			Z = 2'b00;
		end
		S1 : begin
			next_state = (x) ? S0:S2;
			Z = 2'b01;
		end	
		S2 : begin
			next_state = (x) ? S3 : S1;
			Z = 2'b11;
		end
		S3 : begin
			next_state = (x) ? S3 : S2;
			Z = 2'b10;
		end
	endcase
end
endmodule
// Counters
module counter #(parameter size=6)(input clk, reset, input [size-1:0] maxval,output logic [size-1:0] count);
logic [size-1:0] new_count, countn;
logic rst;

register #(6) R1 (new_count, clk, reset, count, countn);
mux21 #(size) ({size{1'b0}}, count + {{size-1{1'b0}}, 1'b1}, reset | rst, new_count);
assign rst = count == maxval;
endmodule

// EXAM 3 New Content
// priority casez
module voltmeter(input [3:0] Vin, output logic V8, V4, V2, V1, V0);
always_comb begin
	V8 = 1'b0; V4 = 1'b0; V2 = 1'b0; V1 = 1'b0; V0 = 1'b0;
	priority casez (Vin)
		4'b1??? : V8 = 1'b1;
		4'b?1?? : V4 = 1'b1;
		4'b??1? : V2 = 1'b1;
		4'b???1 : V1 = 1'b1;
		4'b???? : V0 = 1'b1;
	endcase
end
endmodule

// PWM
module PWM (input clk, reset, input [3:0] x, output logic [3:0] count, output logic pw);
always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		count <= 4'd0;
	else
		count <= count + 4'd1;
end
assign pw = (count < x);
endmodule

module pwm2(input clk, reset, input [3:0] x, output logic [3:0] count, output logic pwm);
DReg #(4) D1 (clk, reset, count + 4'd1, count);
assign pw = (count < x);
endmodule

// Shift Registers
module shiftreg(input clk, reset, x, output logic Y);
logic [4:0] Buf;

always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		Buf <= 5'd0;
	else 
		Buf <= {Buf[3:0], x};
		Y <= Buf[0];
end
endmodule

module shiftreg2(input clk, reset, x, output logic Y);
logic [4:0] Buf;
register #(5) D1 (clk, reset, {Buf[3:0], x}, Buf);
assign Y = Buf[0];
endmodule

// unique casez vs priority casez

// research adders (carry select & look agead carry adder)

look ahead carry adder
	speeds up decoupling the carry calculation

the carry select adder
	reduces the add time on average

Ripple adder
	carry from one bit add to the next rippling to the end sets how long it takes


// verilog vs system verilog
param vs local param
	Localparam are parameters local to that module, parameters can change value on any instance,
	localparam cannot

param vs constants vs variable
	Parameters are names given to constants, parameters and constants must be constant in
	execution where as variable values can change during execution

// structural
module fstruct (input a, b, c, d, output F);
wire ab, cd;
and A1 (ab, a, b);
and A2 (cd, c, d);
or X1 (F, ab, cd);
endmodule

// KMAP REVIEW
literals - number of letters in the equation
terms - is the number of groupings
prime implicants - biggest selections
essentials are the ones with no overlap