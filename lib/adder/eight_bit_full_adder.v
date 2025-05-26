`timescale 1ns / 1ps
// Structural Model

module eight_bit_full_adder (a, b, cin, sum, cout);

	// I/O Declaration
	input [7:0] a, b;
	input cin;
	output [7:0] sum;
	output cout;

	// Wire Declaration	
	wire cout_1, cout_2, cout_3, c_out4, c_out5, c_out6, c_out7;

	// Instantiation
	one_bit_full_adder fa0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(cout_1));
	one_bit_full_adder fa1 (.a(a[1]), .b(b[1]), .cin(cout_1), .sum(sum[1]), .cout(cout_2));
	one_bit_full_adder fa2 (.a(a[2]), .b(b[2]), .cin(cout_2), .sum(sum[2]), .cout(cout_3));
	one_bit_full_adder fa3 (.a(a[3]), .b(b[3]), .cin(cout_3), .sum(sum[3]), .cout(cout_4));	
	one_bit_full_adder fa4 (.a(a[4]), .b(b[4]), .cin(cout_4), .sum(sum[4]), .cout(cout_5));
	one_bit_full_adder fa5 (.a(a[5]), .b(b[5]), .cin(cout_5), .sum(sum[5]), .cout(cout_6));
	one_bit_full_adder fa6 (.a(a[6]), .b(b[6]), .cin(cout_6), .sum(sum[6]), .cout(cout_7));
	one_bit_full_adder fa7 (.a(a[7]), .b(b[7]), .cin(cout_7), .sum(sum[7]), .cout(cout));

endmodule