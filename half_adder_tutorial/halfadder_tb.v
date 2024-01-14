`timescale 1ns/1ps
module addersum_tb(); 
reg A, B;
wire sum, cout;
ha_sum ha1 (sum, cout, A, B);

initial begin 
A=0; B=0; #5;
A=0; B=1; #5;
A=1; B=0; #5;
A=1; B=1; #5;
end
endmodule
