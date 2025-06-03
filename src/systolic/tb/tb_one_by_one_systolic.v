`timescale 1ns / 1ps

module tb_one_by_one_systolic;

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
	o00, o01,
	o10, o11;
	
	one_by_one_systolic systolic (
		clk, rst,

		i00, i01, i02, i03,
		i10, i11, i12, i13,
		i20, i21, i22, i23,
		i30, i31, i32, i33,

		f00, f01, f02,
		f10, f11, f12,
		f20, f21, f22,

		o00, o01,
		o10, o11
		);

	initial forever begin
		#5 clk = ~clk;
	end
	
	initial begin
		{i00, i01, i02, i03, i10, i11, i12, i13, i20, i21, i22, i23, i30, i31, i32, i33}
		<= {8'd8, 8'd3, 8'd9, 8'd1, 8'd7, 8'd7, 8'd2, 8'd8, 8'd5, 8'd6, 8'd3, 8'd1, 8'd4, 8'd9, 8'd2, 8'd6};
		
		{f00, f01, f02, f10, f11, f12, f20, f21, f22}
		<= {8'd1, 8'd5, 8'd8, 8'd6, 8'd0, 8'd7, 8'd3, 8'd1, 8'd2};
		
		clk <= 0;
		rst <= 1;
		#30
		
		rst <= 0;
		#700
		rst <= 1;
		#100
        $finish;
	end

endmodule