`timescale 1ns / 1ps
module xnor_gate(input a, input b, output c);

    wire not_a, not_b;
    wire and_1_out, and_2_out;
    
    not_gate not_1 (a, not_a);
    not_gate not_2 (b, not_b);
    
    and_gate and_1 (a, b, and_1_out);
    and_gate and_2 (not_a, not_b, and_2_out);
    
    or_gate or_1 (and_1_out, and_2_out, c);

endmodule
