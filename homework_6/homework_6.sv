
module mux_41 #(parameter SIZE = 1) (input [SIZE-1:0] A, B, C, D, input [1:0] Sel, output logic [SIZE-1:0] Y); 

always_comb begin
	Y={SIZE{1'b0}};
	case (Sel) 
		2'b00: Y=A;
		2'b01: Y=B;
		2'b10: Y=C;
		2'b11: Y=D;
		default: Y={SIZE{1'b0}};
	endcase
end

endmodule

module D_reg #(parameter SIZE = 1) (input [SIZE-1:0] D, input clk, reset, output logic [SIZE-1:0] Q);

always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		Q <= {SIZE{1'b0}};
	else
		Q <= D;
end

endmodule

// problem 2
module fsm_moore(input x, clk, reset, output logic [1:0] state, output logic [1:0] Z);

localparam S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;
logic [1:0] next_state;

// Determining State
D_reg #(2) D1 (next_state, clk, reset, state);
mux_41 #(2) M1 ((x)?S1:S0, (x)?S2:S0, (x)?S2:S3, (x)?S1:S0, state, next_state);

// Determining Output
mux_41 #(2) M2 (2'b00, 2'b01, 2'b01, 2'b11, state, Z);

endmodule

`timescale 1ns/1ps
module fsm_moore_tb(); 

reg x, clk, reset;
wire [1:0] state, Z;

fsm_moore FSM1 (x, clk, reset, state, Z);

initial begin
		clk = 0; reset=0; x=0;
		#10; x = 0; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 0; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 0; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 1; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 1; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 0; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 0; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 1; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 0; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 1; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 1; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 1; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 0; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 1; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 1; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
end

endmodule

module fsm_mealy(input x, clk , reset, output logic [1:0] state, output logic [1:0] Z);

localparam S0=2'b00, S1=2'b01, S2=2'b10;
logic [1:0] next_state;

D_reg #(2) D1 (next_state, clk, reset, state);
mux_41 #(2) M1 ((x)?S1:S0, (x)?S2:S0, (x)?S2:S0, S0, state, next_state);

mux_41 #(2) M2 ((x)?2'b01:2'b00, (x)?2'b01:2'b00, (x)?2'b10:2'b11, 2'bxx, state, Z);

endmodule


`timescale 1ns/1ps
module fsm_mealy_tb(); 

reg x, clk, reset;
wire [1:0] state, Z;

fsm_mealy FSM1 (x, clk, reset, state, Z);

initial begin
		clk = 0; reset=0; x=0;
		#10; x = 0; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 0; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 0; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 1; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 1; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 0; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 0; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 1; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 0; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 1; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 1; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 1; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 0; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 1; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
		#10; x = 1; clk = 1; #10; $display("State: %b, x: %b, Z: %b", state, x, Z); clk = 0; 
end

endmodule