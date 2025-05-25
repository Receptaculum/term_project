`timescale 1ns / 1ps
module one_bit_half_adder(input a, input b, output sum, output cout);

    xor_gate xor_1 (a, b, sum);
    and_gate and_1 (a, b, cout);

endmodule
