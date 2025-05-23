`timescale 1ns / 1ps
module or_3_gate(input a, input b, input c, output d);

    wire or_1_out;
    
    or_gate or_1 (a, b, or_1_out);
    or_gate or_2 (or_1_out, c, d);

endmodule