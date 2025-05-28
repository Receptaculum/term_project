`timescale 1ns / 1ps

module tb_comparison;

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

    // Single PE
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

    // 2 By 2 Systolic
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

    // 3 By 3 Systolic
	three_by_three_systolic_v2 systolic_3b3_v2 (
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
		#5 clk = ~clk;
	end
	
	initial begin
	    // Input Value
		{i00, i01, i02, i03, i10, i11, i12, i13, i20, i21, i22, i23, i30, i31, i32, i33}
		<= {8'd252, 8'd165, 8'd199, 8'd27, 8'd93, 8'd28, 8'd86, 8'd176, 8'd149, 8'd110, 8'd113, 8'd249, 8'd234, 8'd207, 8'd29, 8'd30};
		
		// Filter Value
		{f00, f01, f02, f10, f11, f12, f20, f21, f22}
		<= {8'd181, 8'd176, 8'd207, 8'd111, 8'd248, 8'd115, 8'd64, 8'd95, 8'd253};
		
		// Clock & Reset Initialization
		clk <= 0;
		rst <= 1;
		
		#20
		rst <= 0;
	end
endmodule