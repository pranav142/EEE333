parameter Width=8; 
parameter Size=5;
typedef struct {logic [Width-1:0] Z [Size-1:0];} REG;

module ShiftRegWd(input clk, reset, input [Width-1:0] X, output REG RReg);
integer i;
always_ff @ (posedge clk or posedge reset) begin
	if (reset)
		RReg.Z[0] <= {Width{1'b0}};
	else begin
		for (i=Size-1;i>0;i=i-1)
			RReg.Z[i] <= RReg.Z[i-1];
		RReg.Z[0] <= X;
	end	
end
endmodule

// problem 1
module Filter_ma(input clk, reset, input [Width-1:0] X, input REG Coef, output logic [Width-1:0] Y);
REG RReg;
logic [Width-1:0] YY;
integer i;
ShiftRegWd SRWd1 (clk, reset, X, RReg);
always_comb begin
	YY = {Width{1'b0}};
	for (i=Size-1;i>0;i=i-1)
		YY = YY + Coef.Z[i] * RReg.Z[i];
end
assign Y = YY;
endmodule

`timescale 1ns/1ps
module filterf_tb();
localparam N = 20;
REG Coef;
integer i, fd, fr, fc, err;
logic clk, reset;
logic [Width-1:0] X, Y;
Filter_ma FO (clk, reset, X, Coef, Y);
initial begin
        fr = $fopen("xinput.csv","r");
        fc = $fopen("coef.csv","r");
        fd = $fopen("filterma.csv");
        $fwrite(fd,"#, X, Y\n");
        for(i=0;i<Size;i=i+1)
		err = $fscanf(fc, "%d", Coef.Z[i]);
        $fclose (fc);
     
        X = 0; clk = 1'b0; reset = 1'b1; #10;
        reset = 1'b0; #10;
        // fill it with zeros by shifting Size times
        for(i=0;i<Size;i=i+1) begin
            clk = 1'b1; #10;
            clk = 1'b0; #10;
        end
        // read serial inputs, and write serial outputs
        for(i=0;i<N;i=i+1) begin
            err = $fscanf(fr, "%d", X);
            clk = 1'b1; #10;
            clk = 1'b0; #10;
            $display("X = %d, Y = %d", X, Y/5);
            $fwrite (fd, "%d, %d, %d\n", i, X, Y/5);
        end
        $fclose(fr);
        $fclose (fd);
    end
endmodule

module FlipFlopW (input clk, rstn, input [Width-1:0] D, output logic [Width-1:0] qout);
always_ff @ (posedge clk or posedge rstn) begin
	if (rstn)
		qout <= {Width{1'b0}};
	else 
		qout <= D;
end
endmodule

module MuxW (input [Width-1:0] Qa, Qb, input select, output logic [Width-1:0] qout);
assign qout = (select) ? Qa : Qb;
endmodule

// Problem 2
module LFSR(input clk, reset, load, input [Width-1:0] seed, output logic [Width-1:0] RandomNumb);
logic [Width-1:0] State_in;
logic nextbit;

FlipFlopW FF8 (clk, reset, State_in, RandomNumb);
MuxW MM8 (seed, {RandomNumb[Width-2:0], nextbit}, load, State_in);
assign nextbit = RandomNumb[7] ^ RandomNumb[5] ^ RandomNumb[4] ^ RandomNumb[3];
endmodule

// Problem 3
`timescale 1ns/1ps
module LFSR_tb();
logic clk, reset, load;
logic [Width-1:0] RandomNumb, seed;
integer i, fd;
LFSR lfsr1 (clk, reset, load, seed, RandomNumb);
initial begin
	fd=$fopen("prob3.csv");
	i=0; clk=0; reset=1; load=0; seed=8'b11111111; #5; clk=1; #5;
	clk=0; reset=0; load=1; #5; clk=1; #5;
	load=0;
	$fwrite(fd,"#, i, Random  Number\n");
	repeat (10) begin
		clk = ~clk; #5;
		i = i + 1;
		$fwrite (fd, "%d, %d\n", i, RandomNumb);
		clk = ~clk; #5;
	end
end	
endmodule
