`timescale 1ns / 1ps

module or_gate (a, b, out); 
	
	input a, b;

	output out;
	
	assign out = a || b;	

endmodule