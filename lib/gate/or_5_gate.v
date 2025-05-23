`timescale 1ns / 1ps
module or_5_gate(input a, input b, input c, input d, input e, output f);

    wire or_1_out;
    
    or_4_gate or_1 (a, b, c, d, or_1_out);
    or_gate or_2 (or_1_out, e, f);

endmodule
