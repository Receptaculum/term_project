`timescale 1ns / 1ps
module decoder_gate_level(input [3:0] d, output [7:0] q);
    
    // [3:0] d === A, B, C, D
    // A', B', C', D'
    wire not_A, not_B, not_C, not_D;
    not_gate not_1 (d[3], not_A);
    not_gate not_2 (d[2], not_B);
    not_gate not_3 (d[1], not_C);
    not_gate not_4 (d[0], not_D);

    // q[7] a
    wire xnor_1_out;
    or_3_gate or_3_1 (xnor_1_out, d[3], d[1], q[7]);
    xnor_gate xnor_1 (d[2], d[0], xnor_1_out);
    
    // q[6] b
    wire xnor_2_out;
    xnor_gate xnor_2 (d[1], d[0], xnor_2_out);
    or_gate or_1 (xnor_2_out, not_B, q[6]);
    
    // q[5] c
    or_4_gate or_4_1 (d[3], d[2], not_C, d[0], q[5]);
    
    // q[4] d
    wire and_1_out, and_2_out, and_3_out;
    wire and_3_1_out;
    or_5_gate or_5_1 (and_1_out, and_2_out, and_3_out, and_3_1_out, d[3], q[4]);
    and_gate and_1 (not_B, not_D, and_1_out);
    and_gate and_2 (not_B, d[1], and_2_out);
    and_gate and_3 (d[1], not_D, and_3_out);
    and_3_gate and_3_1 (d[2], not_C, d[0], and_3_1_out);
    
    // q[3] e
    wire and_4_out, and_5_out;
    or_gate or_2 (and_4_out, and_5_out, q[3]);
    and_gate and_4 (not_B, not_D, and_4_out);
    and_gate and_5 (d[1], not_D, and_5_out);
    
    // q[2] f
    wire and_6_out;
    or_3_gate or_3_2 (and_6_out, d[3], d[2], q[2]);
    and_gate and_6 (not_C, not_D, and_6_out);
    
    // q[1] g
    wire and_7_out, and_8_out, and_9_out;
    or_4_gate or_4_2 (d[3], and_7_out, and_8_out, and_9_out, q[1]);
    and_gate and_7 (d[2], not_C, and_7_out);
    and_gate and_8 (not_B, d[1], and_8_out);
    and_gate and_9 (d[1], not_D, and_9_out);
    
    // q[0] h
    assign q[0] = 0;

endmodule
