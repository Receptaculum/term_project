`timescale 1ns / 1ps
module one_bit_adder_cin(input a, input b, input cin, output sum);

    or_3_gate or_3_1 (a, b, cin, sum);

endmodule