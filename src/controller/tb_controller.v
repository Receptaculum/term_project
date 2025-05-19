`timescale 1ns / 1ps

module tb_controller;

	reg clk, rst;
	wire rst_mem, rst_pe, rst_3b3, rst_2b2, rst_disp;
	wire [2:0] state;

    controller cont (clk, rst,
    rst_mem,
    rst_pe,
    rst_3b3,
    rst_2b2,
    rst_disp,
	
	//임시 추가
	state
);

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