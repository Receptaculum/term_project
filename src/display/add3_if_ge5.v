`timescale 1ns / 1ps
module add3_if_ge5(input [3:0] a, output [3:0] sum);

    wire [3:1] carry;
    
    one_bit_half_adder HA_1 (a[0], mux_out[0], sum[0], carry[1]);
    one_bit_full_adder FA_1 (a[1], mux_out[1], carry[1], sum[1], carry[2]);
    one_bit_full_adder FA_2 (a[2], mux_out[2], carry[2], sum[2], carry[3]);
    one_bit_adder_cin adder_cin_1 (a[3], mux_out[3], carry[3], sum[3]);
    
    // define zero and add_3
    wire [3:0] four_bit_zero;
    wire [3:0] add_3;
    assign four_bit_zero = 4'b0000;
    assign add_3 = 4'b0011;
    
    // mux
    wire sel;
    wire [3:0] mux_out;
    four_bit_2_1_mux mux_1 (four_bit_zero, add_3, sel, mux_out);
    
    // define sel
    wire and_1_out, and_2_out;
    or_3_gate or_3_1 (a[3], and_1_out, and_2_out, sel);
    and_gate and_1 (a[2], a[1], and_1_out);
    and_gate and_2 (a[2], a[0], and_2_out);
    
endmodule