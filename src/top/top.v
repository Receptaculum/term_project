`timescale 1ns / 1ps

module top (clk, rst, digit, seg_data, prev_opt);
	input clk, rst;
	output [2:0] digit;
	output [7:0] seg_data;
    output [7:0] prev_opt;

	(* keep = "true" *) wire rst_mem, rst_pe, rst_3b3, rst_2b2, rst_disp;
	
    (* keep = "true" *) wire [7:0]
	i00, i01, i02, i03,
	i10, i11, i12, i13,
	i20, i21, i22, i23,
	i30, i31, i32, i33;

	(* keep = "true" *) wire [7:0]
	f00, f01, f02,
	f10, f11, f12,
	f20, f21, f22;
	
    (* keep = "true" *) wire [7:0]
	o00_pe, o01_pe,
	o10_pe, o11_pe;

    (* keep = "true" *) wire [7:0]
	o00_3b3, o01_3b3,
	o10_3b3, o11_3b3;
	
    (* keep = "true" *) wire [7:0]
	o00_2b2, o01_2b2,
	o10_2b2, o11_2b2;

    // This code is included for preventing optimization(auto remove) of PE module which is not used
    wire [7:0] prev_opt;
    assign prev_opt = o00_pe + o01_pe + o10_pe + o11_pe;

	// Controller
	(* dont_touch = "true" *) controller control (.clk(clk), .rst(rst),
                        .rst_mem(rst_mem), .rst_pe(rst_pe),
                        .rst_3b3(rst_3b3), .rst_2b2(rst_2b2),
                        .rst_disp(rst_disp));
	
    // Memory	
    (* dont_touch = "true" *) memory mem(.clk(clk), .rst(rst_mem),
    .input_data0(i00), .input_data1(i01), .input_data2(i02), .input_data3(i03), 
    .input_data4(i10), .input_data5(i11), .input_data6(i12), .input_data7(i13),
    .input_data8(i20), .input_data9(i21), .input_data10(i22), .input_data11(i23),
    .input_data12(i30), .input_data13(i31), .input_data14(i32), .input_data15(i33),

    .filter_data0(f00), .filter_data1(f01), .filter_data2(f02),
    .filter_data3(f10), .filter_data4(f11), .filter_data5(f12),
    .filter_data6(f20), .filter_data7(f21), .filter_data8(f22));

    // PE
    (* dont_touch = "true" *) one_by_one_systolic pe (.clk_in(clk), .rst(rst_pe),
    .i00(i00), .i01(i01), .i02(i02), .i03(i03),
    .i10(i10), .i11(i11), .i12(i12), .i13(i13),
    .i20(i20), .i21(i21), .i22(i22), .i23(i23),
    .i30(i30), .i31(i31), .i32(i32), .i33(i33),

    .f00(f00), .f01(f01), .f02(f02),
    .f10(f10), .f11(f11), .f12(f12),
    .f20(f20), .f21(f21), .f22(f22),

    .o00(o00_pe), .o01(o01_pe),
    .o10(o10_pe), .o11(o11_pe)
    );
	
    // 3 By 3 Systolic
    (* dont_touch = "true" *) three_by_three_systolic_v2 three_by_three_v2 (.clk_in(clk), .rst(rst_3b3),
    .i00(i00), .i01(i01), .i02(i02), .i03(i03),
    .i10(i10), .i11(i11), .i12(i12), .i13(i13),
    .i20(i20), .i21(i21), .i22(i22), .i23(i23),
    .i30(i30), .i31(i31), .i32(i32), .i33(i33),

    .f00(f00), .f01(f01), .f02(f02),
    .f10(f10), .f11(f11), .f12(f12),
    .f20(f20), .f21(f21), .f22(f22),

    .o00(o00_3b3), .o01(o01_3b3),
    .o10(o10_3b3), .o11(o11_3b3)
    );	
	
    // 2 By 2 Systolic
    (* dont_touch = "true" *) two_by_two_systolic two_by_two (.clk_in(clk), .rst(rst_2b2),
    .i00(i00), .i01(i01), .i02(i02), .i03(i03),
    .i10(i10), .i11(i11), .i12(i12), .i13(i13),
    .i20(i20), .i21(i21), .i22(i22), .i23(i23),
    .i30(i30), .i31(i31), .i32(i32), .i33(i33),

    .f00(f00), .f01(f01), .f02(f02),
    .f10(f10), .f11(f11), .f12(f12),
    .f20(f20), .f21(f21), .f22(f22),

    .o00(o00_2b2), .o01(o01_2b2),
    .o10(o10_2b2), .o11(o11_2b2)
    );
	
	// Display
	(* dont_touch = "true" *) display disp (.clk(clk), .resetn(rst_disp), .c9_11(o00_3b3), .c9_12(o01_3b3), .c9_21(o10_3b3), .c9_22(o11_3b3), .c4_11(o00_2b2), .c4_12(o01_2b2), .c4_21(o10_2b2), .c4_22(o11_2b2), .digit(digit), .seg_data(seg_data));
	
endmodule