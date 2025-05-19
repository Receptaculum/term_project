`timescale 1ns / 1ps

module tb_top;

	reg clk, rst;
	wire [7:0] o00_pe, o01_pe, o10_pe, o11_pe, o00_3b3, o01_3b3, o10_3b3, o11_3b3, o00_2b2, o01_2b2, o10_2b2, o11_2b2;
	wire [7:0] seg_data;
	wire [2:0] digit;
	wire [2:0] state;

	top top_module (clk, rst, digit, seg_data, o00_pe, o01_pe, o10_pe, o11_pe, o00_3b3, o01_3b3, o10_3b3, o11_3b3, o00_2b2, o01_2b2, o10_2b2, o11_2b2, state);

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