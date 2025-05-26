`timescale 1ns / 1ps
// Gatelevel Model

module one_bit_1_4_demux (a, s0, s1, out1, out2, out3, out4);

	// I/O Declaration
	input a;
	input s0, s1;	
	output out1, out2, out3, out4;

	// Wire Declaration
	wire not_1_output, not_2_output;
	wire and_1_output, and_3_output, and_5_output, and_7_output;

	not_gate not_op_1 (.a(s1), .out(not_1_output));
	not_gate not_op_2 (.a(s0), .out(not_2_output));

	and_gate and_op_1 (.a(not_1_output), .b(not_2_output), .out(and_1_output));
	and_gate and_op_2 (.a(not_1_output), .b(s0), .out(and_3_output));
	and_gate and_op_3 (.a(s1), .b(not_2_output), .out(and_5_output));
	and_gate and_op_4 (.a(s1), .b(s0), .out(and_7_output));

	and_gate and_op_5 (.a(and_1_output), .b(a), .out(out1));
	and_gate and_op_6 (.a(and_3_output), .b(a), .out(out2));
	and_gate and_op_7 (.a(and_5_output), .b(a), .out(out3));
	and_gate and_op_8 (.a(and_7_output), .b(a), .out(out4));
	
endmodule