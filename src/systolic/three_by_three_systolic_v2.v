module three_by_three_systolic_v2 (
clk_in, rst,

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

	/* --I/O Declaration Start-- */

	//Input Matrix
	input [7:0]
	i00, i01, i02, i03,
	i10, i11, i12, i13,
	i20, i21, i22, i23,
	i30, i31, i32, i33;

	//Filter Matrix
	input [7:0]
	f00, f01, f02,
	f10, f11, f12,
	f20, f21, f22;

	//Clock, Reset
	input clk_in, rst;

	//Output Matrix
	output [7:0]
	o00, o01,
	o10, o11;
	
	wire clk;
	
	/* --I/O Declaration End-- */
	
	//------------------------------------------------------------------------------------------
	
	/* --PE Declaration Start-- */
	
	// Wire Declaration for PE
	wire mode_pre, mode_post, pe_rst_pre, pe_rst_post;	
	wire [7:0] a0, a1, a2;
	wire [7:0] b0, b1, b2;
	wire [7:0] w01, w12, w03, w14, w25, w34, w45, w36, w47, w58, w67, w78;
	wire [7:0] c0, c3, c6, c1, c4, c7, c2, c5, c8;
	wire [7:0] out1, out2, out3;
	
	assign c0 = 8'b0;
	assign c1 = 8'b0;
	assign c2 = 8'b0;	
	
	// <PE>
	//
	//		 b_in, c_in
	//           |
	//			 V
	//         ###### <- mode, clk, rst
	// a_in -> # PE # -> a_out
	//         ######
	//           |
	//			 V
	//		b_out, c_out
	
	
	// <Systolic Array>
	//
 	//	    b0, c0      b1, c1	    b2, c2
	//		  |           |			  |
	//        V           V			  V
	// a0 ->  0 -- w01 -- 1	-- w12 -- 2
	//   	  |           |			  |
	// 	   w03, c3     w14, c4	   w25, c5
	//  	  |           |			  |
	// a1 ->  3 -- w34 -- 4 -- w45 -- 5
	//   	  |           |           |
	// 	   w36, c6     w47, c7	   w58, c8
	//  	  |           |           |
	// a2 ->  6 -- w67 -- 7 -- w78 -- 8
	//		  |			  |			  |
	//        V           V           V
	//		 out1        out2        out3

	
	// PE Instantiation
	processing_element pe0 (.clk(clk), .rst(rst | pe_rst_post), .mode(mode_post),
							.a_in(a0), .b_in(b0), .c_in(c0),
							.a_out(w01), .b_out(w03), .c_out(c3));
							
	processing_element pe1 (.clk(clk), .rst(rst | pe_rst_post), .mode(mode_post),
							.a_in(w01), .b_in(b1), .c_in(c1),
							.a_out(w12), .b_out(w14), .c_out(c4));
							
	processing_element pe2 (.clk(clk), .rst(rst | pe_rst_post), .mode(mode_post),
							.a_in(w12), .b_in(b2), .c_in(c2),
							.a_out(), .b_out(w25), .c_out(c5));
							
	processing_element pe3 (.clk(clk), .rst(rst | pe_rst_post), .mode(mode_post),
							.a_in(a1), .b_in(w03), .c_in(c3),
							.a_out(w34), .b_out(w36), .c_out(c6));

	processing_element pe4 (.clk(clk), .rst(rst | pe_rst_post), .mode(mode_post),
							.a_in(w34), .b_in(w14), .c_in(c4),
							.a_out(w45), .b_out(w47), .c_out(c7));
							
	processing_element pe5 (.clk(clk), .rst(rst | pe_rst_post), .mode(mode_post),
							.a_in(w45), .b_in(w25), .c_in(c5),
							.a_out(), .b_out(w58), .c_out(c8));
							
	processing_element pe6 (.clk(clk), .rst(rst | pe_rst_post), .mode(mode_post),
							.a_in(a2), .b_in(w36), .c_in(c6),
							.a_out(w67), .b_out(), .c_out(out1));
							
	processing_element pe7 (.clk(clk), .rst(rst | pe_rst_post), .mode(mode_post),
							.a_in(w67), .b_in(w47), .c_in(c7),
							.a_out(w78), .b_out(), .c_out(out2));
		
	processing_element pe8 (.clk(clk), .rst(rst | pe_rst_post), .mode(mode_post),
							.a_in(w78), .b_in(w58), .c_in(c8),
						    .a_out(), .b_out(), .c_out(out3));

	/* --PE Declaration End-- */

	//------------------------------------------------------------------------------------------

	/* --Memory Declaration Start-- */
	
	// <Memory>
	//
	//		 out1         out2         out3
	//		  |            |			|
	//        V            V			V
	// 	    mem00(dat_1) mem01        mem02
	//   	  |            |	   	    |
	// 	   	 mw1		  mw2	       mw3
	//  	  |            |		    |
	//      mem10        mem11(dat_2) mem12
	//   	  |            |            |
	// 	     mw4          mw5          mw6
	//  	  |            |            |
	//      mem20        mem21     	  mem22(dat_3)
	//   	  |            |            |
	// 	     mw7          mw8          mw9	

	// Wire Declaration
	wire [7:0] mw1, mw2, mw3;
	wire [7:0] mw4, mw5, mw6;
	wire [7:0] mw7, mw8, mw9;
	
	
	// Memory Instantiation
	eight_bit_register mem00 (.in(out1), .clk(clk), .rst(rst), .out(mw1));
	eight_bit_register mem10 (.in(mw1), .clk(clk), .rst(rst), .out(mw4));
	eight_bit_register mem20 (.in(mw4), .clk(clk), .rst(rst), .out(mw7));

	eight_bit_register mem01 (.in(out2), .clk(clk), .rst(rst), .out(mw2));
	eight_bit_register mem11 (.in(mw2), .clk(clk), .rst(rst), .out(mw5));
	eight_bit_register mem21 (.in(mw5), .clk(clk), .rst(rst), .out(mw8));
	
	eight_bit_register mem02 (.in(out3), .clk(clk), .rst(rst), .out(mw3));
	eight_bit_register mem12 (.in(mw3), .clk(clk), .rst(rst), .out(mw6));
	eight_bit_register mem22 (.in(mw6), .clk(clk), .rst(rst), .out(mw9));
	
	
	// Wire Declaration for Sub-Memory
	wire clk_cycle_1_pre, clk_cycle_1_post;
	wire clk_cycle_2_pre, clk_cycle_2_post;
	wire [7:0] o11_1, o11_2, o11_3;

	// Allocation Timing Declaration
	assign clk_cycle_1_pre = cnt == 19;
	assign clk_cycle_2_pre = cnt == 31;
	
	// Hazard Remover
	one_bit_register clk_1_haz (.in(clk_cycle_1_pre), .clk(clk), .rst(rst), .out(clk_cycle_1_post));
	one_bit_register clk_2_haz (.in(clk_cycle_2_pre), .clk(clk), .rst(rst), .out(clk_cycle_2_post));	
	
	// Sub-Memory Instantiation
	eight_bit_register mem_o00 (.in(mw1), .clk(clk_cycle_1_post), .rst(rst), .out(o00));
	eight_bit_register mem_o01 (.in(mw5), .clk(clk_cycle_1_post), .rst(rst), .out(o01));
	eight_bit_register mem_o10 (.in(mw9), .clk(clk_cycle_1_post), .rst(rst), .out(o10));
	
	eight_bit_register mem_o11_1 (.in(mw1), .clk(clk_cycle_2_post), .rst(rst), .out(o11_1));
	eight_bit_register mem_o11_2 (.in(mw5), .clk(clk_cycle_2_post), .rst(rst), .out(o11_2));
	eight_bit_register mem_o11_3 (.in(mw9), .clk(clk_cycle_2_post), .rst(rst), .out(o11_3));

	// Value Addition for o11
	assign o11 = o11_1 + o11_2 + o11_3;

	/* --Memory Declaration End-- */

	//------------------------------------------------------------------------------------------

	/* --Sequence Declaration Start-- */

	// Wire Declaration for Sequences (11 Clock)
	wire [7:0] seq_a0_0_m0, seq_a0_1_m0, seq_a0_2_m0, seq_a0_3_m0;
	wire [7:0] seq_a0_4_m0, seq_a0_5_m0, seq_a0_6_m0, seq_a0_7_m0;
	wire [7:0] seq_a0_8_m0;
	wire [7:0] seq_a0_0_m1, seq_a0_1_m1, seq_a0_2_m1;

	wire [7:0] seq_a1_0_m0, seq_a1_1_m0, seq_a1_2_m0, seq_a1_3_m0;
	wire [7:0] seq_a1_4_m0, seq_a1_5_m0, seq_a1_6_m0, seq_a1_7_m0;
	wire [7:0] seq_a1_8_m0;
	wire [7:0] seq_a1_0_m1, seq_a1_1_m1, seq_a1_2_m1;

	wire [7:0] seq_a2_0_m0, seq_a2_1_m0, seq_a2_2_m0, seq_a2_3_m0;
	wire [7:0] seq_a2_4_m0, seq_a2_5_m0, seq_a2_6_m0, seq_a2_7_m0;
	wire [7:0] seq_a2_8_m0;	
	wire [7:0] seq_a2_0_m1, seq_a2_1_m1, seq_a2_2_m1;

	wire [7:0] seq_b0_0_m0, seq_b0_1_m0, seq_b0_2_m0, seq_b0_3_m0;
	wire [7:0] seq_b0_4_m0, seq_b0_5_m0, seq_b0_6_m0, seq_b0_7_m0;
	wire [7:0] seq_b0_8_m0;
	wire [7:0] seq_b0_0_m1, seq_b0_1_m1, seq_b0_2_m1;
	
	wire [7:0] seq_b1_0_m0, seq_b1_1_m0, seq_b1_2_m0, seq_b1_3_m0;
	wire [7:0] seq_b1_4_m0, seq_b1_5_m0, seq_b1_6_m0, seq_b1_7_m0;
	wire [7:0] seq_b1_8_m0;
	wire [7:0] seq_b1_0_m1, seq_b1_1_m1, seq_b1_2_m1;
	
	wire [7:0] seq_b2_0_m0, seq_b2_1_m0, seq_b2_2_m0, seq_b2_3_m0;
	wire [7:0] seq_b2_4_m0, seq_b2_5_m0, seq_b2_6_m0, seq_b2_7_m0;
	wire [7:0] seq_b2_8_m0;	
	wire [7:0] seq_b2_0_m1, seq_b2_1_m1, seq_b2_2_m1;
	
	
	// Sequence Allocation
	assign {seq_a0_0_m0, seq_a0_1_m0, seq_a0_2_m0, seq_a0_3_m0, seq_a0_4_m0, seq_a0_5_m0, seq_a0_6_m0, seq_a0_7_m0, seq_a0_8_m0} 
	= {i00, i01, i02, i10, i11, i12, i20, i21, i22};

	assign {seq_a0_0_m1, seq_a0_1_m1, seq_a0_2_m1} 
	= {i11, i12, i13};

	assign {seq_a1_0_m0, seq_a1_1_m0, seq_a1_2_m0, seq_a1_3_m0, seq_a1_4_m0, seq_a1_5_m0, seq_a1_6_m0, seq_a1_7_m0, seq_a1_8_m0} 
	= {i01, i02, i03, i11, i12, i13, i21, i22, i23};	

	assign {seq_a1_0_m1, seq_a1_1_m1, seq_a1_2_m1}
	= {i21, i22, i23};

	assign {seq_a2_0_m0, seq_a2_1_m0, seq_a2_2_m0, seq_a2_3_m0, seq_a2_4_m0, seq_a2_5_m0, seq_a2_6_m0, seq_a2_7_m0, seq_a2_8_m0} 
	= {i10, i11, i12, i20, i21, i22, i30, i31, i32};	

	assign {seq_a2_0_m1, seq_a2_1_m1, seq_a2_2_m1}
	= {i31, i32, i33};
	
	assign {seq_b0_0_m0, seq_b0_1_m0, seq_b0_2_m0, seq_b0_3_m0, seq_b0_4_m0, seq_b0_5_m0, seq_b0_6_m0, seq_b0_7_m0, seq_b0_8_m0} 
	= {f22, f21, f20, f12, f11, f10, f02, f01, f00};	

	assign {seq_b0_0_m1, seq_b0_1_m1, seq_b0_2_m1}
	= {f22, f21, f20};
	
	assign {seq_b1_0_m0, seq_b1_1_m0, seq_b1_2_m0, seq_b1_3_m0, seq_b1_4_m0, seq_b1_5_m0, seq_b1_6_m0, seq_b1_7_m0, seq_b1_8_m0} 
	= {f22, f21, f20, f12, f11, f10, f02, f01, f00};	

	assign {seq_b1_0_m1, seq_b1_1_m1, seq_b1_2_m1}
	= {f12, f11, f10};
	
	assign {seq_b2_0_m0, seq_b2_1_m0, seq_b2_2_m0, seq_b2_3_m0, seq_b2_4_m0, seq_b2_5_m0, seq_b2_6_m0, seq_b2_7_m0, seq_b2_8_m0} 
	= {f22, f21, f20, f12, f11, f10, f02, f01, f00};	
	
	assign {seq_b2_0_m1, seq_b2_1_m1, seq_b2_2_m1}
	= {f02, f01, f00};

	/* --Sequence Declaration End-- */

//------------------------------------------------------------------------------------------

	/* --Counter 1 Declaration Start-- */
	
	// Wire Declaration	
	wire [7:0] cnt;
	wire [7:0] cnt_sum;	
	wire [7:0] cnt_sw;
	wire cnt_stop_pre, cnt_stop_post, cnt_stop_neg;
	
	// Module Manipulation Timing 
	// pe_rst_pre = 20 = 10100
	assign pe_rst_pre = cnt[4] & !cnt[3] & cnt[2] & !cnt[1] & !cnt[0]; 
	assign cnt_stop_pre = (cnt >= 31);
	assign cnt_stop_neg = !cnt_stop_post;
	assign mode_pre = ((15 < cnt) & (cnt <= 20) || (27 < cnt) & (cnt <= 30));
	
	// Hazard Remover
	one_bit_register rst_haz (.in(pe_rst_pre), .clk(clk), .rst(rst), .out(pe_rst_post));
    one_bit_register cnt_haz (.in(cnt_stop_pre), .clk(clk), .rst(rst), .out(cnt_stop_post));		
	one_bit_register mode_haz (.in(mode_pre), .clk(clk), .rst(rst), .out(mode_post));		
	
	// Clock Enable
	assign clk = clk_in & cnt_stop_neg;
	
	// Instantiation for Counter 1
	eight_bit_register reg_cnt (.in(cnt_sum), .clk(clk), .rst(rst), .out(cnt)); // Register
	eight_bit_full_adder cnt_add (.a(cnt), .b(cnt_sw), .cin(1'b0), .sum(cnt_sum), .cout()); // Adder
	eight_bit_2_1_mux mux_sw (.a(8'd1), .b(8'd0), .s(cnt_stop_post), .out(cnt_sw)); // Mux (Switch)

	/* --Counter 1 Declaration End-- */	

//------------------------------------------------------------------------------------------

	/* --Sequence Flow Controller Start-- */
	
	// Wire Declaration
	wire [7:0] a0_m0, a0_m1;
	wire [7:0] a1_m0, a1_m1;
	wire [7:0] a2_m0, a2_m1;
	
	wire [7:0] b0_m0, b0_m1;
	wire [7:0] b1_m0, b1_m1;
	wire [7:0] b2_m0, b2_m1;
	
	wire [7:0] a0_pre, a1_pre, a2_pre, b0_pre, b1_pre, b2_pre;

	// Hazard Remover
	eight_bit_register a0_haz (.in(a0_pre), .clk(clk), .rst(rst), .out(a0));
	eight_bit_register a1_haz (.in(a1_pre), .clk(clk), .rst(rst), .out(a1));
	eight_bit_register a2_haz (.in(a2_pre), .clk(clk), .rst(rst), .out(a2));
	eight_bit_register b0_haz (.in(b0_pre), .clk(clk), .rst(rst), .out(b0));
	eight_bit_register b1_haz (.in(b1_pre), .clk(clk), .rst(rst), .out(b1));
	eight_bit_register b2_haz (.in(b2_pre), .clk(clk), .rst(rst), .out(b2));

	// 2:1 Mux for Sequence Interchange
	eight_bit_2_1_mux mux_a0 (.a(a0_m0), .b(a0_m1), .s(cnt[4]), .out(a0_pre));
	eight_bit_2_1_mux mux_a1 (.a(a1_m0), .b(a1_m1), .s(cnt[4]), .out(a1_pre));
	eight_bit_2_1_mux mux_a2 (.a(a2_m0), .b(a2_m1), .s(cnt[4]), .out(a2_pre));
	
	eight_bit_2_1_mux mux_b0 (.a(b0_m0), .b(b0_m1), .s(cnt[4]), .out(b0_pre));
	eight_bit_2_1_mux mux_b1 (.a(b1_m0), .b(b1_m1), .s(cnt[4]), .out(b1_pre));
	eight_bit_2_1_mux mux_b2 (.a(b2_m0), .b(b2_m1), .s(cnt[4]), .out(b2_pre));	

	// 16:1 Mux for Sequence Selction
	eight_bit_16_1_mux mux_a0_m0 (.a(seq_a0_0_m0), .b(seq_a0_1_m0), .c(seq_a0_2_m0), .d(seq_a0_3_m0), 
							      .e(seq_a0_4_m0), .f(seq_a0_5_m0), .g(seq_a0_6_m0), .h(seq_a0_7_m0),
						          .i(seq_a0_8_m0), .j(8'd0), .k(8'd0), .l(8'd0),
							      .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(a0_m0));
							
	eight_bit_16_1_mux mux_a0_m1 (.a(8'd0), .b(8'd0), .c(8'd0), .d(8'd0), 
	                              .e(8'd0), .f(seq_a0_0_m1), .g(seq_a0_1_m1), .h(seq_a0_2_m1), 
						          .i(8'd0), .j(8'd0), .k(8'd0), .l(8'd0),
							      .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(a0_m1));

	eight_bit_16_1_mux mux_a1_m0 (.a(seq_a1_0_m0), .b(seq_a1_1_m0), .c(seq_a1_2_m0), .d(seq_a1_3_m0), 
							      .e(seq_a1_4_m0), .f(seq_a1_5_m0), .g(seq_a1_6_m0), .h(seq_a1_7_m0),
						          .i(seq_a1_8_m0), .j(8'd0), .k(8'd0), .l(8'd0),
						    	  .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(a1_m0));
								
	eight_bit_16_1_mux mux_a1_m1 (.a(8'd0), .b(8'd0), .c(8'd0), .d(8'd0), 
	                              .e(8'd0), .f(seq_a1_0_m1), .g(seq_a1_1_m1), .h(seq_a1_2_m1), 
						          .i(8'd0), .j(8'd0), .k(8'd0), .l(8'd0),
							      .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(a1_m1));				
							   
	eight_bit_16_1_mux mux_a2_m0 (.a(seq_a2_0_m0), .b(seq_a2_1_m0), .c(seq_a2_2_m0), .d(seq_a2_3_m0), 
							      .e(seq_a2_4_m0), .f(seq_a2_5_m0), .g(seq_a2_6_m0), .h(seq_a2_7_m0),
						          .i(seq_a2_8_m0), .j(8'd0), .k(8'd0), .l(8'd0),
							      .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(a2_m0));
								
	eight_bit_16_1_mux mux_a2_m1 (.a(8'd0), .b(8'd0), .c(8'd0), .d(8'd0), 
	                              .e(8'd0), .f(seq_a2_0_m1), .g(seq_a2_1_m1), .h(seq_a2_2_m1), 
						          .i(8'd0), .j(8'd0), .k(8'd0), .l(8'd0),
							      .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(a2_m1));

	eight_bit_16_1_mux mux_b0_m0 (.a(seq_b0_0_m0), .b(seq_b0_1_m0), .c(seq_b0_2_m0), .d(seq_b0_3_m0), 
							      .e(seq_b0_4_m0), .f(seq_b0_5_m0), .g(seq_b0_6_m0), .h(seq_b0_7_m0),
						          .i(seq_b0_8_m0), .j(8'd0), .k(8'd0), .l(8'd0),
							      .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(b0_m0));

	eight_bit_16_1_mux mux_b0_m1 (.a(8'd0), .b(8'd0), .c(8'd0), .d(8'd0), 
	                              .e(8'd0), .f(seq_b0_0_m1), .g(seq_b0_1_m1), .h(seq_b0_2_m1), 
						          .i(8'd0), .j(8'd0), .k(8'd0), .l(8'd0),
							      .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(b0_m1));

	eight_bit_16_1_mux mux_b1_m0 (.a(seq_b1_0_m0), .b(seq_b1_1_m0), .c(seq_b1_2_m0), .d(seq_b1_3_m0), 
							      .e(seq_b1_4_m0), .f(seq_b1_5_m0), .g(seq_b1_6_m0), .h(seq_b1_7_m0),
						          .i(seq_b1_8_m0), .j(8'd0), .k(8'd0), .l(8'd0),
							      .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(b1_m0));

	eight_bit_16_1_mux mux_b1_m1 (.a(8'd0), .b(8'd0), .c(8'd0), .d(8'd0), 
	                              .e(8'd0), .f(seq_b1_0_m1), .g(seq_b1_1_m1), .h(seq_b1_2_m1), 
						          .i(8'd0), .j(8'd0), .k(8'd0), .l(8'd0),
							      .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(b1_m1));		
							   
	eight_bit_16_1_mux mux_b2_m0 (.a(seq_b2_0_m0), .b(seq_b2_1_m0), .c(seq_b2_2_m0), .d(seq_b2_3_m0), 
							      .e(seq_b2_4_m0), .f(seq_b2_5_m0), .g(seq_b2_6_m0), .h(seq_b2_7_m0),
						          .i(seq_b2_8_m0), .j(8'd0), .k(8'd0), .l(8'd0),
							      .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(b2_m0));

	eight_bit_16_1_mux mux_b2_m1 (.a(8'd0), .b(8'd0), .c(8'd0), .d(8'd0), 
	                              .e(8'd0), .f(seq_b2_0_m1), .g(seq_b2_1_m1), .h(seq_b2_2_m1), 
						          .i(8'd0), .j(8'd0), .k(8'd0), .l(8'd0),
							      .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(b2_m1));
	
	/* --Sequence Flow Controller End-- */
	
endmodule