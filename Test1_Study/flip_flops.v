module SRlatch(input S, R, En, output reg Q, output Qn);

always @ (*) begin
	if (En)
		if (S==1 && R==1)
			Q=1'bx;
		else 
			Q=S|~R &Q;
end 
assign Qn = ~Q;
endmodule

module Dlathch(input D, En, output reg Q, output Qn);

wire Q_;
SRlatch SR1 (D, ~D, En, Q_, Qn);
always @ (*)
	Q = Q_;

endmodule

module SR_FlipFlop(input S, R, aReset, Clk, output reg Q, output Qn);

always @ (posedge Clk or posedge aReset) begin
	if (aReset)
		Q <= 1'b0; // make sure to use non blocking assign
	else if (S==1 && R==1)
		Q <= 1'bx;	
	else
		Q <= S|Q&~R;
end

assign Qn = ~Q;

endmodule

module JK_FlipFlop(input S, R, aReset, Clk, output reg Q, output Qn);

always @ (posedge Clk or posedge aReset) begin
	if (aReset)
		Q <= 1'b0;
	else 
		Q <= S&~R|S&~Q|Q&~R;
end

assign Qn = ~Q;

endmodule


module T_FlipFlop(input T, aReset, Clk, output reg Q, output Qn);

wire Q_;
JK_FlipFlop JK1 (T, T, aReset, Clk, Q_, Qn);
always @ (*)
	Q=Q_;
endmodule

module D_FlipFlop(input D, aReset, Clk, output reg Q, output Qn);
wire Q_;
JK_FlipFlop JK1 (D, ~D, aReset, Clk, Q_, Qn);
always @ (*)
	Q=Q_;
endmodule

module Tff_(output reg Q, output Qn, input T, Reset, En, Set, Clk);
always @ (posedge Clk or posedge Reset or posedge Set) begin
	if (Reset)
		Q <= 1'b0; 
	else if (Set)
		Q <= 1'b1;
	else if (En)
		Q <= T^Q;		
end
assign Qn = ~Q;
endmodule

module sync_counter(input Clk, En, reset, output [3:0] Q);
wire Qn;
T_FlipFlop t1 (En, reset, Clk, Q[0], Qn);
T_FlipFlop t2 (Q[0], reset, Clk, Q[1], Qn);
T_FlipFlop t3 (Q[0] & Q[1], reset, Clk, Q[2], Qn);
T_FlipFlop t4 (Q[0] & Q[1] & Q[2], reset, Clk, Q[3], Qn);
endmodule

module pcounter(input Reset, Enable, Clk, input [3:0] Qmax, output reg [3:0] Q);
always @(posedge Clk or posedge Reset) begin 
	if (Reset)
		Q <= 4'b0000;
	else if (Enable)
		if (Q < Qmax)
			Q <= Q + 4'b0001;
		else 
			Q <= 4'b0000;
end
endmodule

module freq_divider(input reset, clk, input [3:0] maxcount, output reg [3:0] count, output reg clkout);
always @ (posedge clk or posedge reset)
	if (reset) begin
		count <= 4'b0000;
		clkout <= 1'b0;
	end
	else if (count < maxcount) begin
		count <= count + 4'b0001; 
		clkout <= 1'b0;
	end
	else begin
		count <= 4'b0000;
		clkout <= 1'b1;
	end
endmodule

module pcounter50(input reset, clk, input [3:0] maxcount, output reg [3:0] count, output reg clkout);
always @ (posedge clk or posedge reset)
	if (reset) begin
		count <=4'b0000;
		clkout <= 1'b0;
	end
	else if (count < maxcount) 
		count <= count + 4'b0001;
	else begin
		count <= 4'b0000;
		clkout <= ~clkout;
	end
endmodule

module mux21_ #(parameter Size=3) (input [Size-1:0] A, B, input Sel, output reg [Size-1:0] Out);

always @ (*) begin
	Out = A;
	case (Sel)
		1'b0: Out = A;
		1'b1: Out = B;
		default: Out = A;
	endcase
end


endmodule

module Dreg #(parameter Size = 3) (input [Size-1:0] D, input clk, reset, output reg [Size-1:0] Q, Qn);
always @ (posedge clk or posedge reset) begin
	if (reset)
		Q <= {Size{1'b0}};
	else 
		Q <= D;
end
assign Qn = ~Q;
endmodule