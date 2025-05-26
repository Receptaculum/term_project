`timescale 1ns / 1ps
// Gatelevel Model

module one_bit_2_1_mux (a, b, s, out);

	// I/O Declaration
	input a, b, s;	
	output out;
	
	// Wire Declaration
	wire not_1_output;
	wire and_1_output, and_2_output;
	
	// Instantiation
	not_gate not_1(.a(s), .out(not_1_output));
	and_gate and_1(.a(a), .b(not_1_output), .out(and_1_output));
	and_gate and_2(.a(b), .b(s), .out(and_2_output));
	or_gate or_1(.a(and_1_output), .b(and_2_output), .out(out));

endmodule