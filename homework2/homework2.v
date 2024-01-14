
// problem 1
module homework2_1(output F, Fs, input A, B, C);
assign F=~A&~B&~C|A&~B&~C|A&B&~C|A&B&C;
assign Fs=A&B|~B&~C;
endmodule

// protblem 2
module homework2_2(output F, Fs, input A, B, C, D);
assign F=~A&B&~C&~D|~A&~B&C&D|A&B&C&~D|~A&B&~C&D|A&B&~C&D|~A&B&C&D|A&B&C&D;
assign Fs=~A&B&~C|~A&C&D|A&B&C|B&D;
endmodule

