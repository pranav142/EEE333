// hello when key is up (1) and intiials when key is down (0)

// 8 bit ascii can represent A - Z, 0-9
// Hexidecimal segment has 7 segments that can light up
// when hex seg is set to 0 it turns led on
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

module ASCIICodes(input Kkey0, output [6:0] HexSeg4, HexSeg3, HexSeg2, HexSeg1, HexSeg0);
	reg [7:0] Message [4:0];
	always @ (*) begin
		Message[4] = 8'd0; 
		Message[3] = 8'd0;
		Message[2] = 8'd0;
		Message[1] = 8'd0;
		Message[0] = 8'd0;
		case (Kkey0)
			1'b1 : begin
				Message[4] = "H"; 
				Message[3] = "e";
				Message[2] = "l"; 
				Message[1] = "l"; 
				Message[0] = "O";
			end
			// Show My Initials (Pranav Nadimpalli: PN)
			1'b0 : begin
				Message[1] = "P"; 
				Message[0] = "N";
			end
			default : begin 
				Message[4] = "H"; 
				Message[3] = "e";
				Message[2] = "l"; 
				Message[1] = "l"; 
				Message[0] = "O";
			end
		endcase
	end

	ASCII27Seg SegH4 (Message[4], HexSeg4);
	ASCII27Seg SegH3 (Message[3], HexSeg3);
	ASCII27Seg SegH2 (Message[2], HexSeg2);
	ASCII27Seg SegH1 (Message[1], HexSeg1);
	ASCII27Seg SegH0 (Message[0], HexSeg0);
endmodule

module Dec27Seg(input [7:0] Decimal, output reg [6:0] HexSeg);
	always @ (*) begin
		HexSeg = 7'd0;
		case (Decimal)
			// 0
			8'd0 : begin
				HexSeg[6] = 1'b1;
			end
			// 1
			8'd1 : begin
				HexSeg[6] = 1'b1; HexSeg[0] = 1'b1; HexSeg[3] = 1'b1; HexSeg[5] = 1'b1; HexSeg[4] = 1'b1;
			end
			// 2
			8'd2 : begin
				HexSeg[5] = 1'b1; HexSeg[2] = 1'b1;
			end
			// 3
			8'd3 : begin
				HexSeg[5] = 1'b1; HexSeg[4] = 1'b1;
			end
			// 4
			8'd4 : begin
				HexSeg[0] = 1'b1; HexSeg[4] = 1'b1; HexSeg[3] = 1'b1;
			end
			// 5
			8'd5 : begin
				HexSeg[1] = 1'b1; HexSeg[4] = 1'b1;
			end
			// 6
			8'd6 :HexSeg[1] = 1'b1;
			// 7
			8'd7 : begin
				HexSeg[5] = 1'b1; HexSeg[4] = 1'b1; HexSeg[6] = 1'b1; HexSeg[3] = 1'b1;
			end
			// 8
			8'd8 : HexSeg = 7'd0;
			// 9
			8'd9 : HexSeg[4] = 1'b1;
			default: HexSeg = 7'b1111111;
		endcase
	end
endmodule

// Tests
`timescale 1ns/1ps
module ascii_numb_tb();
	reg [7:0] AsciiCode;
	wire [6:0] HexSeg;

	ASCII27Seg A1 (AsciiCode, HexSeg);

	// testing numbers 0 - 9
	initial begin
		AsciiCode = "0"; #10;
		AsciiCode = "1"; #10;
		AsciiCode = "2"; #10;
		AsciiCode = "3"; #10;
		AsciiCode = "4"; #10;
		AsciiCode = "5"; #10;
		AsciiCode = "6"; #10;
		AsciiCode = "7"; #10;
		AsciiCode = "8"; #10;
		AsciiCode = "9"; #10;
	end
endmodule

`timescale 1ns/1ps
module decimal_numb_tb();
	reg [7:0] decimalCode;
	wire [6:0] HexSeg;

	Dec27Seg D1 (decimalCode, HexSeg);

	// testing numbers 0 - 9
	initial begin
		decimalCode = 8'd0; #10;
		decimalCode = 8'd1; #10;
		decimalCode = 8'd2; #10;
		decimalCode = 8'd3; #10;
		decimalCode = 8'd4; #10;
		decimalCode = 8'd5; #10;
		decimalCode = 8'd6; #10;
		decimalCode = 8'd7; #10;
		decimalCode = 8'd8; #10;
		decimalCode = 8'd9; #10;
	end
endmodule