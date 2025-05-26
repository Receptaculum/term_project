`timescale 1ns / 1ps
// Gatelevel Model

module one_bit_4_1_mux (a, b, c, d, s0, s1, out);

	// I/O Declaration
	input a, b, c, d;
	input s0, s1;	
	output out;
	
	// Wire Declaration
	wire not_1_output, not_2_output;
	wire and_1_output, and_2_output, and_3_output, and_4_output,
	     and_5_output, and_6_output, and_7_output, and_8_output;
	wire or_1_output, or_2_output;
	
	// Instantiation
	not_gate not_op_1 (.a(s1), .out(not_1_output));
	not_gate not_op_2 (.a(s0), .out(not_2_output));

	and_gate and_op_1 (.a(not_1_output), .b(not_2_output), .out(and_1_output));
	and_gate and_op_2 (.a(not_1_output), .b(s0), .out(and_2_output));
	and_gate and_op_3 (.a(s1), .b(not_2_output), .out(and_3_output));
	and_gate and_op_4 (.a(s1), .b(s0), .out(and_4_output));

	and_gate and_op_5 (.a(and_1_output), .b(a), .out(and_5_output));
	and_gate and_op_6 (.a(and_2_output), .b(b), .out(and_6_output));
	and_gate and_op_7 (.a(and_3_output), .b(c), .out(and_7_output));
	and_gate and_op_8 (.a(and_4_output), .b(d), .out(and_8_output));

	or_gate or_op_1 (.a(and_5_output), .b(and_6_output), .out(or_1_output));
	or_gate or_op_2 (.a(and_7_output), .b(and_8_output), .out(or_2_output));

	or_gate or_op_3 (.a(or_1_output), .b(or_2_output), .out(out));
	
endmodule
