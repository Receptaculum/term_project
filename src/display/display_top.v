`timescale 1ns / 1ps
module display_top(
    input clk,
    input resetn,
    output [2:0] digit,
    output [7:0] seg_data
    );
    
    wire [7:0] c9_11 = 8'd1;
    wire [7:0] c9_12 = 8'd2;
    wire [7:0] c9_21 = 8'd4;
    wire [7:0] c9_22 = 8'd8;
    wire [7:0] c4_11 = 8'd16;
    wire [7:0] c4_12 = 8'd32;
    wire [7:0] c4_21 = 8'd64;
    wire [7:0] c4_22 = 8'd128;
    
    display dut (
    clk, resetn, c9_11, c9_12, c9_21, c9_22, c4_11, c4_12, c4_21, c4_22, digit, seg_data
    );

    

endmodule
