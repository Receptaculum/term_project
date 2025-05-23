`timescale 1ns / 1ps
module and_3_gate(input a, input b, input c, output d);

    wire and_1_out;
    
    and_gate and_1 (a, b, and_1_out);
    and_gate and_2 (and_1_out, c, d);

endmodule