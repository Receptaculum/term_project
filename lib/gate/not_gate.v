`timescale 1ns / 1ps

module not_gate (a, out); 
	
	input a;

	output out;

	assign out = !a;

endmodule