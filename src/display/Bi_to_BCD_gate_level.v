`timescale 1ns / 1ps
module Bi_to_BCD_gate_level(
    input [7:0] Bi,
    output [3:0] f,
    output [3:0] s,
    output [3:0] t
    );
    
    // define zero
    wire zero;
    assign zero = 1'b0;
    
    // define wire
    wire [3:0] add3_1_out, add3_2_out, add3_3_out, add3_4_out, add3_5_out, add3_6_out, add3_7_out;
    
    add3_if_ge5 add3_1 ({zero, Bi[7], Bi[6], Bi[5]}, add3_1_out);
    add3_if_ge5 add3_2 ({add3_1_out[2:0], Bi[4]}, add3_2_out);
    add3_if_ge5 add3_3 ({add3_2_out[2:0], Bi[3]}, add3_3_out);
    add3_if_ge5 add3_4 ({zero, add3_1_out[3], add3_2_out[3], add3_3_out[3]}, add3_4_out);
    add3_if_ge5 add3_5 ({add3_3_out[2:0], Bi[2]}, add3_5_out);
    add3_if_ge5 add3_6 ({add3_4_out[2:0], add3_5_out[3]}, add3_6_out);
    add3_if_ge5 add3_7 ({add3_5_out[2:0], Bi[1]}, add3_7_out);
    
    assign f = {zero, zero, add3_4_out[3], add3_6_out[3]};
    assign s = {add3_6_out[2:0], add3_7_out[3]};
    assign t = {add3_7_out[2:0], Bi[0]};
    
endmodule
