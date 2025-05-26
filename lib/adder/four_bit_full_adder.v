`timescale 1ns / 1ps
// Structural Model

module four_bit_full_adder (a, b, cin, sum, cout);

	// I/O Declaration
	input [3:0] a, b;
	input cin;
	output [3:0] sum;
	output cout;

	// Wire Declaration	
	wire cout_1, cout_2, cout_3;

	// Instantiation
	one_bit_full_adder fa0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(cout_1));
	one_bit_full_adder fa1 (.a(a[1]), .b(b[1]), .cin(cout_1), .sum(sum[1]), .cout(cout_2));
	one_bit_full_adder fa2 (.a(a[2]), .b(b[2]), .cin(cout_2), .sum(sum[2]), .cout(cout_3));
	one_bit_full_adder fa3 (.a(a[3]), .b(b[3]), .cin(cout_3), .sum(sum[3]), .cout(cout));	

endmodule