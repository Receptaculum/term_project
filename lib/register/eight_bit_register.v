`timescale 1ns / 1ps
// Structural Model

module eight_bit_register (in, clk, rst, out);

	// Input
	input [7:0] in;
	input clk, rst;
	
	// Output
	output [7:0] out;

	// Module Instantiation
	one_bit_register one_bit_reg_0 (.in(in[0]), .clk(clk), .rst(rst), .out(out[0]));
	one_bit_register one_bit_reg_1 (.in(in[1]), .clk(clk), .rst(rst), .out(out[1]));
	one_bit_register one_bit_reg_2 (.in(in[2]), .clk(clk), .rst(rst), .out(out[2]));
	one_bit_register one_bit_reg_3 (.in(in[3]), .clk(clk), .rst(rst), .out(out[3]));
	one_bit_register one_bit_reg_4 (.in(in[4]), .clk(clk), .rst(rst), .out(out[4]));
	one_bit_register one_bit_reg_5 (.in(in[5]), .clk(clk), .rst(rst), .out(out[5]));
	one_bit_register one_bit_reg_6 (.in(in[6]), .clk(clk), .rst(rst), .out(out[6]));
	one_bit_register one_bit_reg_7 (.in(in[7]), .clk(clk), .rst(rst), .out(out[7]));
	
endmodule