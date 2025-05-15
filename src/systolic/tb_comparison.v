//`timescale 1ns / 1ps

module tb_comparision;

	reg clk, rst;

	reg [7:0]
	i00, i01, i02, i03,
	i10, i11, i12, i13,
	i20, i21, i22, i23,
	i30, i31, i32, i33;

	reg [7:0]
	f00, f01, f02,
	f10, f11, f12,
	f20, f21, f22;

	wire [7:0]
	o00_1, o01_1,
	o10_1, o11_1;
	
	wire [7:0]
	o00_2, o01_2,
	o10_2, o11_2;

	wire [7:0]
	o00_3, o01_3,
	o10_3, o11_3;

	one_by_one_systolic systolic_1b1 (
		clk, rst,

		i00, i01, i02, i03,
		i10, i11, i12, i13,
		i20, i21, i22, i23,
		i30, i31, i32, i33,

		f00, f01, f02,
		f10, f11, f12,
		f20, f21, f22,

		o00_1, o01_1,
		o10_1, o11_1
		);

	two_by_two_systolic systolic_2b2 (
		clk, rst,

		i00, i01, i02, i03,
		i10, i11, i12, i13,
		i20, i21, i22, i23,
		i30, i31, i32, i33,

		f00, f01, f02,
		f10, f11, f12,
		f20, f21, f22,

		o00_2, o01_2,
		o10_2, o11_2
		);
		
	three_by_three_systolic systolic_3b3 (
		clk, rst,

		i00, i01, i02, i03,
		i10, i11, i12, i13,
		i20, i21, i22, i23,
		i30, i31, i32, i33,

		f00, f01, f02,
		f10, f11, f12,
		f20, f21, f22,

		o00_3, o01_3,
		o10_3, o11_3
		);

	initial forever begin
		#10 clk = ~clk;
	end
	
	initial begin
		{i00, i01, i02, i03, i10, i11, i12, i13, i20, i21, i22, i23, i30, i31, i32, i33}
		<= {8'd9, 8'd8, 8'd2, 8'd6, 8'd0, 8'd4, 8'd1, 8'd6, 8'd4, 8'd10, 8'd1, 8'd1, 8'd2, 8'd2, 8'd9, 8'd9};
		
		{f00, f01, f02, f10, f11, f12, f20, f21, f22}
		<= {8'd3, 8'd2, 8'd0, 8'd2, 8'd0, 8'd1, 8'd3, 8'd1, 8'd1};
		
		clk <= 0;
		rst <= 1;
		#20
		
		rst <= 0;
		#500
		
		rst <= 1;
		#20
		rst <= 0;
	end

endmodule