`timescale 1ns / 1ps
module or_4_gate(input a, input b, input c, input d, output e);

    wire or_1_out;
    
    or_3_gate or_1 (a, b, c, or_1_out);
    or_gate or_2 (or_1_out, d, e);

endmodule