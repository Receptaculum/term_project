// Basic Gate

module and_gate (a, b, out); 
	
	// I/O Declaration
	input a, b;
	output out;
	
	// Assignment
	assign out = a && b;

endmodule