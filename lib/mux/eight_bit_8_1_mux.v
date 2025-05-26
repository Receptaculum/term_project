`timescale 1ns / 1ps
// Structural Model

module eight_bit_8_1_mux (a, b, c, d, e, f, g, h, s0, s1, s2, out);

	// I/O Declaration
	input [7:0] a, b, c, d, e, f, g, h;
	input s0, s1, s2;	
	output [7:0] out;

	// Wire Declaration
	wire [7:0] out_0, out_1;

	// Instantiation
	eight_bit_4_1_mux mux_1 (.a(a), .b(b), .c(c), .d(d), .s0(s0), .s1(s1), .out(out_0));
	eight_bit_4_1_mux mux_2 (.a(e), .b(f), .c(g), .d(h), .s0(s0), .s1(s1), .out(out_1));
	eight_bit_2_1_mux mux_m (.a(out_0), .b(out_1), .s(s2), .out(out));
	
endmodule