// Basic Gate

module not_gate (a, out); 
	
	// I/O Declaration
	input a;
	output out;

	// Assignment
	assign out = !a;

endmodule
