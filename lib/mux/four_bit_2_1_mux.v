`timescale 1ns / 1ps
// Structural Model

module four_bit_2_1_mux (a, b, s, out);

	// I/O Declaration
	input [3:0] a, b;
	input s;	
	output [3:0] out;
	
	// Instantiation
	one_bit_2_1_mux mux_0 (.a(a[0]), .b(b[0]), .s(s), .out(out[0]));
	one_bit_2_1_mux mux_1 (.a(a[1]), .b(b[1]), .s(s), .out(out[1]));
	one_bit_2_1_mux mux_2 (.a(a[2]), .b(b[2]), .s(s), .out(out[2]));
	one_bit_2_1_mux mux_3 (.a(a[3]), .b(b[3]), .s(s), .out(out[3]));

endmodule
