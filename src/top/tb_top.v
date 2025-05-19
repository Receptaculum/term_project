`timescale 1ns / 1ps

module tb_top;

	reg clk, rst;
	wire [7:0] seg_data;
	wire [2:0] digit;
	
	top top_module (clk, rst, digit, seg_data);

	initial begin 
		clk <= 0;
		rst <= 1;
		
		#5
		rst <= 0;
		
		#500
		rst <= 1;
	end

	initial forever begin
		#5 clk <= !clk;
	end

endmodule