`timescale 1ns / 1ps

module and_gate (a, b, out); 
	
	input a, b;

	output out;
	
	assign out = a & b;

endmodule