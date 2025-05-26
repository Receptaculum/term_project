`timescale 1ns / 1ps
// Structural Model

module eight_bit_2_1_mux (a, b, s, out);

	// I/O Declaration
	input [7:0] a, b; 
	input s;	
	output [7:0] out;
	
	// Instantiation 
	one_bit_2_1_mux mux_0 (.a(a[0]), .b(b[0]), .s(s), .out(out[0])); 
	one_bit_2_1_mux mux_1 (.a(a[1]), .b(b[1]), .s(s), .out(out[1])); 
	one_bit_2_1_mux mux_2 (.a(a[2]), .b(b[2]), .s(s), .out(out[2])); 
	one_bit_2_1_mux mux_3 (.a(a[3]), .b(b[3]), .s(s), .out(out[3])); 
	one_bit_2_1_mux mux_4 (.a(a[4]), .b(b[4]), .s(s), .out(out[4])); 
	one_bit_2_1_mux mux_5 (.a(a[5]), .b(b[5]), .s(s), .out(out[5])); 
	one_bit_2_1_mux mux_6 (.a(a[6]), .b(b[6]), .s(s), .out(out[6])); 
	one_bit_2_1_mux mux_7 (.a(a[7]), .b(b[7]), .s(s), .out(out[7])); 

endmodule