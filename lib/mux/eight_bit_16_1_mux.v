`timescale 1ns / 1ps
// Structural Model

module eight_bit_16_1_mux (a, b, c, d, e, f, g, h, i, j, k, l , m, n, o, p, s0, s1, s2, s3, out);

	// I/O Declaration
	input [7:0] a, b, c, d;
	input [7:0] e, f, g, h;
	input [7:0] i, j, k, l;
	input [7:0] m, n, o, p;
	input s0, s1, s2, s3;
	output [7:0] out;

	// Wire Declaration
	wire [7:0] out_0, out_1, out_2, out_3;

	// Instantiation
	eight_bit_4_1_mux mux_0 (.a(a), .b(b), .c(c), .d(d), .s0(s0), .s1(s1), .out(out_0));
	eight_bit_4_1_mux mux_1 (.a(e), .b(f), .c(g), .d(h), .s0(s0), .s1(s1), .out(out_1));
	eight_bit_4_1_mux mux_2 (.a(i), .b(j), .c(k), .d(l), .s0(s0), .s1(s1), .out(out_2));
	eight_bit_4_1_mux mux_3 (.a(m), .b(n), .c(o), .d(p), .s0(s0), .s1(s1), .out(out_3));
	eight_bit_4_1_mux mux_m (.a(out_0), .b(out_1), .c(out_2), .d(out_3), .s0(s2), .s1(s3), .out(out));	
	
endmodule