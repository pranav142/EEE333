
module SRFF_Fsm(input S, R, Clk, reset, output reg Q, output Qn);
    reg Qnext;
    // synchronous part
    always @ (posedge Clk or posedge reset) begin
        if (reset) // asynchronous reset
            Q <= 1'b0;
        else
            Q <= Qnext;
    end
    // combinatorial part
    always @ (*) begin
        Qnext = S|~R&Q;
    end
    assign Qn = ~Q;
endmodule