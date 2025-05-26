`timescale 1ns / 1ps
// Gatelevel Model

module xor_gate (a, b, out);

	// I/O Declaration
    input a, b;
    output out;

	// Wire Declaration
    wire a_neg, b_neg;
    wire and_out_1, and_out_2;

	//Instantiation
    not_gate not_op_1 (.a(a), .out(a_neg));
    not_gate not_op_2 (.a(b), .out(b_neg));

    and_gate and_op_1 (.a(a), .b(b_neg), .out(and_out_1));    
    and_gate and_op_2 (.a(a_neg), .b(b), .out(and_out_2));

    or_gate or_op_1 (.a(and_out_1), .b(and_out_2), .out(out));
	
endmodule