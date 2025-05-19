`timescale 1ns / 1ps
module Bi_to_BCD(
    input [7:0] Bi,
    output [3:0] f,
    output [3:0] s,
    output [3:0] t
    );
    
    assign f = (Bi % 1000) / 100;
    assign s = (Bi % 100) / 10;
    assign t = Bi % 10;

endmodule
