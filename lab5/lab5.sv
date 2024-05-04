module mux41 #(parameter size=8)(input [size-1:0] A, B, C, D, input [1:0] sel, output logic [size-1:0] Y);
always_comb begin
	Y = {size{1'b0}};
	case (sel)
		2'b00 : Y = A;
		2'b01 : Y = B;
		2'b10 : Y = C;	
		2'b11 : Y = D;
		default : Y = {size{1'bx}};
	endcase
end
endmodule

module mux16_1 #(parameter size=8)(input [size-1:0] A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, input [3:0] sel, output logic [size-1:0] Y);
logic [size-1:0] mux_outs [3:0];
mux41 #(size) m1(A, B, C, D, sel[1:0], mux_outs[0]);
mux41 #(size) m2(E, F, G, H, sel[1:0], mux_outs[1]);
mux41 #(size) m3(I, J, K, L, sel[1:0], mux_outs[2]);
mux41 #(size) m4(M, N, O, P, sel[1:0], mux_outs[3]);
mux41 #(size) m5(mux_outs[0], mux_outs[1], mux_outs[2], mux_outs[3], sel[3:2], Y);
endmodule

module add #(parameter size=8) (input [size-1:0] A, B, output logic [size-1:0] sum, output logic cout, OF);
assign {cout, sum} = {1'b0,A}+{1'b0,B};
assign OF = A[size-1]&B[size-1]&cout&~sum[size-1] | ~A[size-1]&~B[size-1]&~cout&sum[size-1];
endmodule

module sub #(parameter size=8) (input [size-1:0] A, B, output logic [size-1:0] sum, output logic cout, OF);
assign {cout,sum} = {1'b0, A} + {1'b0,-B};
assign OF = A[size-1]&B[size-1]&cout&~sum[size-1] | ~A[size-1]&~B[size-1]&~cout&sum[size-1];
endmodule

module alu (input [7:0] A, B, input [3:0] RA, RB, input [3:0] OPCODE, output logic [7:0] alu_out, output logic cout, OF);

logic [7:0] add, ldi, sub, adi, mul, div, dec, inc, nor_, nand_, xor_, comp;
logic [7:0] cmpj, jmp, hlt;
logic cout_add, of_add, cout_sub, of_sub, cout_adi, of_adi, cout_dec, of_dec, cout_inc, of_inc;

add A1 (A, B, add, cout_add, of_add);
assign ldi = {RA, RB};
sub S1 (A, B, sub, cout_sub, of_sub);
add A2 (A, {4'b0,RB}, adi, cout_adi, of_adi);
assign mul = A * B;
assign div = A/B;
sub S2 (B, 8'd1, dec, cout_dec, of_dec);
add A3 (B, 8'd1, inc, cout_inc, of_inc);
assign nor_ = ~(A | B);
assign nand_ = ~(A & B);
assign xor_ = A ^ B;
assign comp = ~B;
assign cmpj = 8'd0;
assign jmp = 8'd0;
assign hlt = 8'd0;

mux16_1 #(8) m1(8'd0, add, ldi, sub, adi, mul, div, dec, inc, nor_, nand_, xor_, comp, cmpj, jmp, hlt, OPCODE, alu_out);
mux16_1 #(1) m2(1'd0, cout_add, 1'd0, cout_sub, cout_adi, 1'd0, 1'd0, cout_dec, cout_inc, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, OPCODE, cout);
mux16_1 #(1) m3(1'd0, of_add, 1'd0, of_sub, of_adi, 1'd0, 1'd0, of_dec, of_inc, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, OPCODE, OF);

endmodule

module RegFile(input reset, clk, input [3:0] RA, input [3:0] RB, input [3:0] RD, input [3:0] OPCODE, input [1:0] current_state, input [7:0] RF_data_in, output logic [7:0] RF_data_out0, output logic [7:0] RF_data_out1);
localparam IF=2'b00, FD=2'b01, EX=2'b10, RWB=2'b11;
logic [7:0] RF [15:0];

always_ff @ (posedge clk or posedge reset) begin
	if (reset) begin
		RF_data_out0 <= 8'd0;
		RF_data_out1 <= 8'd0;
		RF[15] <= 8'd0;
		RF[14] <= 8'd0;
		RF[13] <= 8'd0;
		RF[12] <= 8'd0;
		RF[11] <= 8'd0;
		RF[10] <= 8'd0;
		RF[9] <= 8'd0;
		RF[8] <= 8'd0;
		RF[7] <= 8'd0;
		RF[6] <= 8'd0;
		RF[5] <= 8'd0;
		RF[4] <= 8'd0;
		RF[3] <= 8'd0;
		RF[2] <= 8'd0;
		RF[1] <= 8'd0;
		RF[0] <= 8'd0;
	end
	else begin
		if (current_state == IF) begin
			RF_data_out0 <= RF[RA];
			RF_data_out1 <= RF[RB];
		end
		else if (current_state == RWB && (OPCODE != 4'd13) && (OPCODE != 4'd14) && (OPCODE != 4'd15)) begin
			RF[RD] <= RF_data_in;
		end
	end
end
endmodule

module ROM(input [7:0] PC, output logic [15:0] IR);
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
assign mem[11] = 16'h6536;
assign mem[12] = 16'h5637;
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

// mcu control block
module Dreg #(parameter size=8)(input clk, reset, input [size-1:0] D, output logic [size-1:0] Q);
always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		Q <= {size{1'b0}};
	else
		Q <= D;
end
endmodule

module mcu_control(input clk, reset, input [7:0] PC, input [3:0] OPCODE, input [3:0] RA, RB, RD, input [7:0] A, B, output logic [7:0] new_pc, output logic [1:0] state);
localparam IF=2'b00, FD=2'b01, EX=2'b10, RWB=2'b11;
logic [1:0] next_state;
Dreg #(2) D1 (clk, reset, next_state, state);
mux41 #(2) M1 (FD, EX, RWB, IF, state, next_state);

always_comb begin
	new_pc = PC;
	if (OPCODE == 4'b1111)
		new_pc = PC;
	else if (state == RWB) begin
		if (OPCODE == 4'b1110) 
			new_pc = {RA, RB};
		else if (OPCODE == 4'b1101)
			if (A >= B)
				new_pc = PC + {4'd0, RD};
			else 
				new_pc = PC + {7'd0, 1'b1};
		else 
			new_pc = PC + {7'd0, 1'b1};
	end
end

endmodule

module lab5(input clk, reset, output logic [3:0] OPCODE, output logic [1:0] State, output logic [7:0] PC, Alu_out, W_reg, output logic Cout, OF);
localparam IF=2'b00, FD=2'b01, EX=2'b10, RWB=2'b11;
//integer fd;

logic [3:0] RA, RB, RD;
logic [7:0] A, B, next_PC;
logic [15:0] IR;

// IF
ROM R1(PC, IR);

assign OPCODE = IR[15:12];
assign RA = IR[11:8];
assign RB = IR[7:4];
assign RD = IR[3:0];

// FD
RegFile RF (reset, clk, RA, RB, RD, OPCODE, State, W_reg, A, B);

// EX
alu A1 (A, B, RA, RB, OPCODE, Alu_out, Cout, OF);

// RWB
Dreg #(8) w_reg(clk, reset, (State == EX) ? Alu_out : W_reg, W_reg);
Dreg #(8) pc(clk, reset, next_PC, PC);

mcu_control MC (clk, reset, PC, OPCODE, RA, RB, RD, A, B, next_PC, State);

//initial begin
//        fd = $fopen("test1.csv", "w");  // Open the file for writing
//        if (fd) $fwrite(fd, "PC,IR,OPCODE,RA,RB,RD,W_Reg,Cout,OF\n"); 
//end

//always_ff @(posedge clk)
//    	if (State == EX)
//            $fwrite(fd, "%h,%h,%h,%h,%h,%h,%h,%h,%h\n", 
//                    PC, IR, OPCODE, RA, RB, RD, W_reg, Cout, OF);

//final begin
//	$fclose(fd);
//end

endmodule

`timescale 1ns/1ps
module lab5_tb();
logic clk, reset, Cout, OF;
logic [3:0] OPCODE;
logic [1:0] State;
logic [7:0] PC, Alu_out, W_reg;

lab5 L1 (clk, reset, OPCODE, State, PC, Alu_out, W_reg, Cout, OF);

initial begin

clk=1'b0; reset=1'b1; #5;
clk=1'b1; reset=1'b0; #5;

repeat (1000) begin
	clk = ~clk; #5;
end

end
endmodule

module freq_div #(parameter size=8) (input clk, reset, input [size-1:0] count_max, output logic [size-1:0] count, output logic clkout);
localparam Zero = {size{1'b0}}, One={{size-1{1'b0}}, 1'b1};

always_ff @ (posedge clk or posedge reset) begin
	if (reset) begin
		count <= Zero;
		clkout <= 1'b0;
	end
	else if (count < count_max) 
		count <= count + One;
	else begin
		count <= Zero;
		clkout <= ~clkout;
	end
end
endmodule

module ASCII27Seg(input [7:0] AsciiCode, output reg [6:0] HexSeg);
    always @ (*) begin 
        HexSeg = 7'd0;
        $display("AsciiCode %b", AsciiCode);
        case (AsciiCode)
            // ------Upper Case Letters -----
            // A
            8'h41 : HexSeg[3] = 1'b1;
            // B
            8'h42 : begin
				HexSeg[0] = 1'b1; HexSeg[1] = 1'b1;
			end
            // C
            8'h43 : begin
				HexSeg[1] = 1'b1; HexSeg[2] = 1'b1; HexSeg[6] = 1'b1;
			end
            // D
            8'h44 : begin
				HexSeg[0] = 1'b1; HexSeg[5] = 1'b1; 
			end
            // E
            8'h45 : begin
				HexSeg[1] = 1'b1; HexSeg[2] = 1'b1; 
			end
            // F
            8'h46 : begin
				HexSeg[1] = 1'b1; HexSeg[2] = 1'b1; HexSeg[3] = 1'b1;
			end
            // G
            8'h47 : HexSeg[4] = 1'b1;
            // H
            8'h48 : begin
				HexSeg[0] = 1'b1; HexSeg[3] = 1'b1;
			end
            // I
            8'h49 : begin
				HexSeg = 7'b1111111; HexSeg[5] = 1'b0; HexSeg[4] = 1'b0;
			end
            // J
            8'h4A : begin
				HexSeg[0] = 1'b1; HexSeg[6] = 1'b1; HexSeg[5] = 1'b1; 
			end
            // K 
            8'h4B : begin
				HexSeg[0] = 1'b1; HexSeg[3] = 1'b1;
			end
            // L
            8'h4C : begin
				HexSeg[0] = 1'b1; HexSeg[1] = 1'b1; HexSeg[2] = 1'b1; HexSeg[6] = 1'b1;  
			end
            // M 
            8'h4D : begin
				HexSeg[1] = 1'b1; HexSeg[5] = 1'b1; HexSeg[6] = 1'b1; HexSeg[3] = 1'b1;
			end
            // N
            8'h4E : begin
				HexSeg[0] = 1'b1; HexSeg[1] = 1'b1; HexSeg[5] = 1'b1; HexSeg[3] = 1'b1;
			end
            // O
            8'h4F : HexSeg[6] = 1'b1;
            // P
            8'h50 : begin
				HexSeg[2] = 1'b1; HexSeg[3] = 1'b1;
			end
            // Q 
            8'h51 : begin 
				HexSeg[4] = 1'b1; HexSeg[3] = 1'b1;
			end
            // R
            8'h52 : begin
				HexSeg[5] = 1'b1; HexSeg[0] = 1'b1; HexSeg[1] = 1'b1; HexSeg[2] = 1'b1; HexSeg[3] = 1'b1;
			end
            // S
            8'h53 : begin 
				HexSeg[1] = 1'b1; HexSeg[4] = 1'b1;
			end
            // T
            8'h54 : begin 
				HexSeg[0] = 1'b1; HexSeg[1] = 1'b1; HexSeg[2] = 1'b1;
			end
            // U
            8'h55 : begin
				HexSeg[0] = 1'b1; HexSeg[6] = 1'b1;
			end
            // V 
            8'h56 : begin
				HexSeg[0] = 1'b1; HexSeg[6] = 1'b1; HexSeg[1] = 1'b1; HexSeg[5] = 1'b1;
			end 
            // W 
            8'h57 : begin 
				HexSeg[0] = 1'b1; HexSeg[6] = 1'b1; HexSeg[4] = 1'b1; HexSeg[2] = 1'b1;
			end
            // X 
            8'h58 : begin 
				HexSeg[0] = 1'b1; HexSeg[3] = 1'b1;
			end
            // Y
            8'h59 : begin
				HexSeg[0] = 1'b1; HexSeg[4] = 1'b1;
			end
            // Z 
            8'h5A : begin
				HexSeg[5] = 1'b1; HexSeg[2] = 1'b1;
			end

			// ------Lower Case Letters-----
			// a
			8'h61 : HexSeg[3] = 1'b1;
			// b
			8'h62 : begin
				HexSeg[0] = 1'b1; HexSeg[1] = 1'b1;
			end
			// c
			8'h63 : begin
				HexSeg[1] = 1'b1; HexSeg[2] = 1'b1; HexSeg[6] = 1'b1;
			end
			// d
			8'h64 : begin
				HexSeg[0] = 1'b1; HexSeg[5] = 1'b1; 
			end
			// e
			8'h65 : begin
				HexSeg[1] = 1'b1; HexSeg[2] = 1'b1; 
			end
			// f
			8'h66 : begin
				HexSeg[1] = 1'b1; HexSeg[2] = 1'b1; HexSeg[3] = 1'b1;
			end
			// g
			8'h67 : HexSeg[4] = 1'b1;
			// h
			8'h68 : begin
				HexSeg[0] = 1'b1; HexSeg[3] = 1'b1;
			end
			// i
			8'h69 : begin
				HexSeg = 7'b1111111; HexSeg[5] = 1'b0; HexSeg[4] = 1'b0;
			end
			// j
			8'h6A : begin
				HexSeg[0] = 1'b1; HexSeg[6] = 1'b1; HexSeg[5] = 1'b1; 
			end
			// k
			8'h6B : begin
				HexSeg[0] = 1'b1; HexSeg[3] = 1'b1;
			end
			// l
			8'h6C : begin
				HexSeg[0] = 1'b1; HexSeg[1] = 1'b1; HexSeg[2] = 1'b1; HexSeg[6] = 1'b1;  
			end
			// m
			8'h6D : begin
				HexSeg[1] = 1'b1; HexSeg[5] = 1'b1; HexSeg[6] = 1'b1; HexSeg[3] = 1'b1;
			end
			// n
			8'h6E : begin
				HexSeg[0] = 1'b1; HexSeg[1] = 1'b1; HexSeg[5] = 1'b1; HexSeg[3] = 1'b1;
			end
			// o
			8'h6F : HexSeg[6] = 1'b1;
			// p
			8'h70 : begin
				HexSeg[2] = 1'b1; HexSeg[3] = 1'b1;
			end
			// q
			8'h71 : begin 
				HexSeg[4] = 1'b1; HexSeg[3] = 1'b1;
			end
			// r
			8'h72 : begin
				HexSeg[5] = 1'b1; HexSeg[0] = 1'b1; HexSeg[1] = 1'b1; HexSeg[2] = 1'b1; HexSeg[3] = 1'b1;
			end
			// s
			8'h73 : begin 
				HexSeg[1] = 1'b1; HexSeg[4] = 1'b1;
			end
			// t
			8'h74 : begin 
				HexSeg[0] = 1'b1; HexSeg[1] = 1'b1; HexSeg[2] = 1'b1;
			end
			// u
			8'h75 : begin
				HexSeg[0] = 1'b1; HexSeg[6] = 1'b1;
			end
			// v
            8'h76 : begin
				HexSeg[0] = 1'b1; HexSeg[6] = 1'b1; HexSeg[1] = 1'b1; HexSeg[5] = 1'b1;
			end 
            // w 
            8'h77 : begin 
				HexSeg[0] = 1'b1; HexSeg[6] = 1'b1; HexSeg[4] = 1'b1; HexSeg[2] = 1'b1;
			end
            // x 
            8'h78 : begin 
				HexSeg[0] = 1'b1; HexSeg[3] = 1'b1;
			end
            // y
            8'h79 : begin
				HexSeg[0] = 1'b1; HexSeg[4] = 1'b1;
			end
            // z 
            8'h7A : begin
				HexSeg[5] = 1'b1; HexSeg[2] = 1'b1;
			end

			// ------Numbers-----
			// 0
			8'h30 : begin
				HexSeg[6] = 1'b1;
			end
			// 1
			8'h31 : begin
				HexSeg[6] = 1'b1; HexSeg[0] = 1'b1; HexSeg[3] = 1'b1; HexSeg[5] = 1'b1; HexSeg[4] = 1'b1;
			end
			// 2
			8'h32 : begin
				HexSeg[5] = 1'b1; HexSeg[2] = 1'b1;
			end
			// 3
			8'h33 : begin
				HexSeg[5] = 1'b1; HexSeg[4] = 1'b1;
			end
			// 4
			8'h34 : begin
				HexSeg[0] = 1'b1; HexSeg[4] = 1'b1; HexSeg[3] = 1'b1;
			end
			// 5
			8'h35 : begin
				HexSeg[1] = 1'b1; HexSeg[4] = 1'b1;
			end
			// 6
			8'h36 :HexSeg[1] = 1'b1;
			// 7
			8'h37 : begin
				HexSeg[5] = 1'b1; HexSeg[4] = 1'b1; HexSeg[6] = 1'b1; HexSeg[3] = 1'b1;
			end
			// 8
			8'h38 : HexSeg = 7'd0;
			// 9
			8'h39 : HexSeg[4] = 1'b1;
            default : HexSeg = 7'b1111111;
        endcase
    end
endmodule

module to_Ascii(input [7:0] num, output logic [7:0] hi, med, lo);
assign hi = num / 8'd100 + 8'h30;
assign med = (num % 8'd100) / 8'd10 + 8'h30;
assign lo = (num % 8'd100) % 8'd10 + 8'h30;
endmodule

module lab5_pv(input clk, SW0, SW1, KEY0, SW2, SW3, SW4, output logic [6:0] SevSeg5, SevSeg4, SevSeg3, SevSeg2, SevSeg1, SevSeg0, output logic LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7);

logic Cout, OF, slow_clk;
logic [3:0] OPCODE;
logic [1:0] State;
logic [7:0] PC, Alu_out, W_reg;
logic [25:0] count;
logic [2:0] led_sw;
assign led_sw = {SW4, SW3, SW2};

logic [7:0] Ascii5, Ascii4, Ascii3, Ascii2, Ascii1, Ascii0;
logic [7:0] PC_hi, PC_med, PC_lo, OP_hi, OP_med, OP_lo, W_hi, W_med, W_lo, A_hi, A_med, A_lo;

ASCII27Seg A1(Ascii5, SevSeg5);
ASCII27Seg A2(Ascii4, SevSeg4);
ASCII27Seg A3(Ascii3, SevSeg3);
ASCII27Seg A4(Ascii2, SevSeg2);
ASCII27Seg A5(Ascii1, SevSeg1);
ASCII27Seg A6(Ascii0, SevSeg0);

to_Ascii T1(PC, PC_hi, PC_med, PC_lo);
to_Ascii T2({4'b0, OPCODE}, OP_hi, OP_med, OP_lo);
to_Ascii T3(W_reg, W_hi, W_med, W_lo);
to_Ascii T4(Alu_out, A_hi, A_med, A_lo);

freq_div #(26) f1 (clk, SW0, 26'd12500000, count, slow_clk);
lab5 L1 ((SW1) ? ~KEY0 : slow_clk, SW0, OPCODE, State, PC, Alu_out, W_reg, Cout, OF);

assign {LED7, LED6, LED5, LED4, LED3, LED2, LED1, LED0} = PC;

always_comb begin
	{Ascii5, Ascii4, Ascii3, Ascii2, Ascii1, Ascii0} = {"nadimp"};
	case(led_sw)
		3'b000: {Ascii5, Ascii4, Ascii3, Ascii2, Ascii1, Ascii0} = {"nadimp"};
		3'b110: begin
			Ascii5 = 8'h30;
			Ascii4 = 8'h30;
			Ascii3 = 8'h30;
			Ascii2 = PC_hi;
			Ascii1 = PC_med;
			Ascii0 = PC_lo;
		end
		3'b101: begin
			Ascii5 = 8'h30;
			Ascii4 = 8'h30;
			Ascii3 = 8'h30;
			Ascii2 = W_hi;
			Ascii1 = W_med;
			Ascii0 = W_lo;
		end
		3'b011: begin
			Ascii5 = 8'h30;
			Ascii4 = 8'h30;
			Ascii3 = 8'h30;
			Ascii2 = A_hi;
			Ascii1 = A_med;
			Ascii0 = A_lo;
		end
		3'b111: begin
			Ascii5 = 8'h30;
			Ascii4 = 8'h30;
			Ascii3 = 8'h30;
			Ascii2 = OP_hi;
			Ascii1 = OP_med;
			Ascii0 = OP_lo;
		end
		default: begin
			Ascii5 = 8'h0;
			Ascii4 = 8'h0;
			Ascii3 = 8'h0;
			Ascii2 = 8'h0;
			Ascii1 = 8'h0;
			Ascii0 = 8'h0;
		end
	endcase
end
endmodule
