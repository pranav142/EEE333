module ha_sum(output sum, cout, input A, B);
wire ssum;
xor x1(sum, A, B);
and a1 (cout, A, B);
assign ssum=sum;
endmodule
