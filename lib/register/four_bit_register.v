`timescale 1ns / 1ps
// Structural Model

module four_bit_register (in, clk, rst, out);

	// Input
	input [3:0] in;
	input clk, rst;
	
	// Output
	output [3:0] out;

	// Module Instantiation
	one_bit_register one_bit_reg_0 (.in(in[0]), .clk(clk), .rst(rst), .out(out[0]));
	one_bit_register one_bit_reg_1 (.in(in[1]), .clk(clk), .rst(rst), .out(out[1]));
	one_bit_register one_bit_reg_2 (.in(in[2]), .clk(clk), .rst(rst), .out(out[2]));
	one_bit_register one_bit_reg_3 (.in(in[3]), .clk(clk), .rst(rst), .out(out[3]));
	
endmodule