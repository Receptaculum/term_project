module memory (clk, rst,
i00, i01, i02, i03,
i10, i11, i12, i13,
i20, i21, i22, i23,
i30, i31, i32, i33,

f00, f01, f02,
f10, f11, f12,
f20, f21, f22
);

	// I/O Declaration
	input clk, rst;

	output [7:0]
	i00, i01, i02, i03,
	i10, i11, i12, i13,
	i20, i21, i22, i23,
	i30, i31, i32, i33;

	output [7:0]
	f00, f01, f02,
	f10, f11, f12,
	f20, f21, f22;
	
	
	// Register Instantiation
	eight_bit_register reg_i00 (.in(8'd9), .clk(clk), .rst(rst), .out(i00));
	eight_bit_register reg_i01 (.in(8'd8), .clk(clk), .rst(rst), .out(i01));
	eight_bit_register reg_i02 (.in(8'd2), .clk(clk), .rst(rst), .out(i02));
	eight_bit_register reg_i03 (.in(8'd6), .clk(clk), .rst(rst), .out(i03));
	eight_bit_register reg_i10 (.in(8'd0), .clk(clk), .rst(rst), .out(i10));
	eight_bit_register reg_i11 (.in(8'd4), .clk(clk), .rst(rst), .out(i11));
	eight_bit_register reg_i12 (.in(8'd1), .clk(clk), .rst(rst), .out(i12));
	eight_bit_register reg_i13 (.in(8'd6), .clk(clk), .rst(rst), .out(i13));
	eight_bit_register reg_i20 (.in(8'd4), .clk(clk), .rst(rst), .out(i20));
	eight_bit_register reg_i21 (.in(8'd10), .clk(clk), .rst(rst), .out(i21));
	eight_bit_register reg_i22 (.in(8'd1), .clk(clk), .rst(rst), .out(i22));
	eight_bit_register reg_i23 (.in(8'd1), .clk(clk), .rst(rst), .out(i23));
	eight_bit_register reg_i30 (.in(8'd2), .clk(clk), .rst(rst), .out(i30));
	eight_bit_register reg_i31 (.in(8'd2), .clk(clk), .rst(rst), .out(i31));
	eight_bit_register reg_i32 (.in(8'd9), .clk(clk), .rst(rst), .out(i32));
	eight_bit_register reg_i33 (.in(8'd9), .clk(clk), .rst(rst), .out(i33));
	
	eight_bit_register reg_f00 (.in(8'd3), .clk(clk), .rst(rst), .out(f00));
	eight_bit_register reg_f01 (.in(8'd2), .clk(clk), .rst(rst), .out(f01));
	eight_bit_register reg_f02 (.in(8'd0), .clk(clk), .rst(rst), .out(f02));
	eight_bit_register reg_f10 (.in(8'd2), .clk(clk), .rst(rst), .out(f10));
	eight_bit_register reg_f11 (.in(8'd0), .clk(clk), .rst(rst), .out(f11));
	eight_bit_register reg_f12 (.in(8'd1), .clk(clk), .rst(rst), .out(f12));
	eight_bit_register reg_f20 (.in(8'd3), .clk(clk), .rst(rst), .out(f20));
	eight_bit_register reg_f21 (.in(8'd1), .clk(clk), .rst(rst), .out(f21));
	eight_bit_register reg_f22 (.in(8'd1), .clk(clk), .rst(rst), .out(f22));
	
endmodule