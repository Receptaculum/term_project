`timescale 1ns / 1ps
// Gatelevel Model

module one_bit_full_adder (a, b, cin, sum, cout);

	// I/O Declaration
	input a, b, cin;
	output sum, cout;

	// Wire Declaration
	wire xor_out_1;
	wire and_out_1, and_out_2, and_out_3;
	wire or_out_1;

	//sum
	xor_gate xor_op_1 (.a(a), .b(b), .out(xor_out_1));
	xor_gate xor_op_2 (.a(xor_out_1), .b(cin), .out(sum));

	//cout
	and_gate and_op_1 (.a(a), .b(cin), .out(and_out_1));
	and_gate and_op_2 (.a(b), .b(cin), .out(and_out_2));
	and_gate and_op_3 (.a(a), .b(b), .out(and_out_3));

	or_gate or_op_1 (.a(and_out_2), .b(and_out_3), .out(or_out_1));
	or_gate or_op_2 (.a(and_out_1), .b(or_out_1), .out(cout));

endmodule