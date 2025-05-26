`timescale 1ns / 1ps
// Behavioral Model

module one_bit_register (in, clk, rst, out);

	// I/O Declaration
	input in, clk, rst;	
	output out;
	
	// Reg Declaration
	reg out;	
	
	always @ (posedge clk or posedge rst) begin
	
		if(rst == 1'b1) begin
			out <= 1'b0; 
		end
			
		else begin
			out <= in;
		end
		
	end

endmodule