


// Structural model this wil use 
module modexample(input A, B, output C); 
// default data type is wire
wire C1, C2; // local to this module
and A1 (C1, A, ~B); // C1 = AB' 
and A2 (C2, ~A, B); // C2 = A'B
or X1 (C, C1, C2); // C = C1 + C2 = AB' + A'B'
// A1 and A2 are instance names
endmodule

//behavioral model
module modexample1(input A, B, output C);
assign C  = ~A&B | A&~B; // similar to soldering wires
endmodule

`timescale 1ns/1ps  // time scale
module modexamp_tb(); 
reg A1, B1;
wire C1, C2;

modexample M1(A1, B1, C1); 
modexample1 M2(A1, B1, C2);
initial begin 
    A1 = 1'b1;
    B1 = 1'b0;
    #10; // time delay
end
endmodule