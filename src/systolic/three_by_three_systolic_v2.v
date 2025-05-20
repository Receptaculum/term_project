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
	assign clk = clk_in;
	
	/* --I/O Declaration End-- */
	
	//------------------------------------------------------------------------------------------
	
	/* --PE Declaration Start-- */
	
	// Wire Declaration for PE
	wire mode, pe_rst;	
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
	processing_element pe0 (.clk(clk), .rst(rst | pe_rst), .mode(mode),
							.a_in(a0), .b_in(b0), .c_in(c0),
							.a_out(w01), .b_out(w03), .c_out(c3));
							
	processing_element pe1 (.clk(clk), .rst(rst | pe_rst), .mode(mode),
							.a_in(w01), .b_in(b1), .c_in(c1),
							.a_out(w12), .b_out(w14), .c_out(c4));
							
	processing_element pe2 (.clk(clk), .rst(rst | pe_rst), .mode(mode),
							.a_in(w12), .b_in(b2), .c_in(c2),
							.a_out(), .b_out(w25), .c_out(c5));
							
	processing_element pe3 (.clk(clk), .rst(rst | pe_rst), .mode(mode),
							.a_in(a1), .b_in(w03), .c_in(c3),
							.a_out(w34), .b_out(w36), .c_out(c6));

	processing_element pe4 (.clk(clk), .rst(rst | pe_rst), .mode(mode),
							.a_in(w34), .b_in(w14), .c_in(c4),
							.a_out(w45), .b_out(w47), .c_out(c7));
							
	processing_element pe5 (.clk(clk), .rst(rst | pe_rst), .mode(mode),
							.a_in(w45), .b_in(w25), .c_in(c5),
							.a_out(), .b_out(w58), .c_out(c8));
							
	processing_element pe6 (.clk(clk), .rst(rst | pe_rst), .mode(mode),
							.a_in(a2), .b_in(w36), .c_in(c6),
							.a_out(w67), .b_out(), .c_out(out1));
							
	processing_element pe7 (.clk(clk), .rst(rst | pe_rst), .mode(mode),
							.a_in(w67), .b_in(w47), .c_in(c7),
							.a_out(w78), .b_out(), .c_out(out2));
		
	processing_element pe8 (.clk(clk), .rst(rst | pe_rst), .mode(mode),
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
	// 	    mem00(o11_1) mem01        mem02
	//   	  |            |	   	    |
	// 	   	 mw1		  mw2	       mw3
	//  	  |            |		    |
	//      mem10        mem11(o11_2) mem12
	//   	  |            |            |
	// 	     mw4          mw5          mw6
	//  	  |            |            |
	//      mem20        mem21     	  mem22(o11_3)
	//   	  |            |            |
	// 	     mw7          mw8          mw9	
	//   	  |            |            |
	// 	    mem30(o00)   mem31        mem32
	//   	  |            |	   	    |
	// 	   	 mw10		  mw11	       mw12
	//  	  |            |		    |
	//      mem40        mem41(o01)   mem42
	//   	  |            |            |
	// 	     mw13         mw14         mw15
	//  	  |            |            |
	//      mem50        mem51     	  mem52(o10)
	//   	  |            |            |
	// 	     mw16         mw17         mw18
	
	// Wire Declaration
	wire clk_mem;
	wire [7:0] mw1, mw2, mw3;
	wire [7:0] mw4, mw5, mw6;
	wire [7:0] mw7, mw8, mw9;
	wire [7:0] mw10, mw11, mw12;
	wire [7:0] mw13, mw14, mw15;
	wire [7:0] mw16, mw17, mw18;
	
	assign clk_mem = mode & clk;
	
	// Memory Instantiation
	eight_bit_register mem00 (.in(out1), .clk(clk_mem), .rst(rst), .out(mw1));
	eight_bit_register mem10 (.in(mw1), .clk(clk_mem), .rst(rst), .out(mw4));
	eight_bit_register mem20 (.in(mw4), .clk(clk_mem), .rst(rst), .out(mw7));
	eight_bit_register mem30 (.in(mw7), .clk(clk_mem), .rst(rst), .out(mw10));
	eight_bit_register mem40 (.in(mw10), .clk(clk_mem), .rst(rst), .out(mw13));
	eight_bit_register mem50 (.in(mw13), .clk(clk_mem), .rst(rst), .out(mw16));

	eight_bit_register mem01 (.in(out2), .clk(clk_mem), .rst(rst), .out(mw2));
	eight_bit_register mem11 (.in(mw2), .clk(clk_mem), .rst(rst), .out(mw5));
	eight_bit_register mem21 (.in(mw5), .clk(clk_mem), .rst(rst), .out(mw8));
	eight_bit_register mem31 (.in(mw8), .clk(clk_mem), .rst(rst), .out(mw11));
	eight_bit_register mem41 (.in(mw11), .clk(clk_mem), .rst(rst), .out(mw14));
	eight_bit_register mem51 (.in(mw14), .clk(clk_mem), .rst(rst), .out(mw17));
	
	eight_bit_register mem02 (.in(out3), .clk(clk_mem), .rst(rst), .out(mw3));
	eight_bit_register mem12 (.in(mw3), .clk(clk_mem), .rst(rst), .out(mw6));
	eight_bit_register mem22 (.in(mw6), .clk(clk_mem), .rst(rst), .out(mw9));
	eight_bit_register mem32 (.in(mw9), .clk(clk_mem), .rst(rst), .out(mw12));
	eight_bit_register mem42 (.in(mw12), .clk(clk_mem), .rst(rst), .out(mw15));
	eight_bit_register mem52 (.in(mw15), .clk(clk_mem), .rst(rst), .out(mw18));
	
	// Wiring between reg and out
	assign o00 = mw10;
	assign o01 = mw14;
	assign o10 = mw18;
	assign o11 = mw1 + mw5 + mw9;

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
	// Counter 1 is utilized for MUX manipulation

	// Wire Declaration	
	wire [7:0] cnt;
	wire [7:0] cnt_sum;	
	wire [7:0] cnt_sw;
	wire cnt_stop_pre;

	// Counter Stop Condition 
	assign pe_rst = (cnt == 16);
	assign mode = (12 < cnt)& (cnt < 16) ;
	assign cnt_stop_pre = 0;
	
	// Instantiation for Counter 1
	eight_bit_register reg_cnt (.in(cnt_sum), .clk(clk), .rst(rst), .out(cnt)); // Register
	eight_bit_full_adder cnt_add (.a(cnt), .b(cnt_sw), .cin(1'b0), .sum(cnt_sum), .cout()); // Adder
	eight_bit_2_1_mux mux_sw (.a(8'd1), .b(8'd0), .s(cnt_stop_pre), .out(cnt_sw)); // Mux (Switch)

	/* --Counter 1 Declaration End-- */	

//------------------------------------------------------------------------------------------

	/* --Sequence Flow Controller Start-- */
	
	wire [7:0] a0_m0, a0_m1;
	wire [7:0] a1_m0, a1_m1;
	wire [7:0] a2_m0, a2_m1;
	
	wire [7:0] b0_m0, b0_m1;
	wire [7:0] b1_m0, b1_m1;
	wire [7:0] b2_m0, b2_m1;

	eight_bit_2_1_mux mux_a0 (.a(a0_m0), .b(a0_m1), .s(cnt[4]), .out(a0));
	eight_bit_2_1_mux mux_a1 (.a(a1_m0), .b(a1_m1), .s(cnt[4]), .out(a1));
	eight_bit_2_1_mux mux_a2 (.a(a2_m0), .b(a2_m1), .s(cnt[4]), .out(a2));
	
	eight_bit_2_1_mux mux_b0 (.a(b0_m0), .b(b0_m1), .s(cnt[4]), .out(b0));
	eight_bit_2_1_mux mux_b1 (.a(b1_m0), .b(b1_m1), .s(cnt[4]), .out(b1));
	eight_bit_2_1_mux mux_b2 (.a(b2_m0), .b(b2_m1), .s(cnt[4]), .out(b2));	

	// Mux Instantiation for Sequence Selction
	eight_bit_16_1_mux mux_a0_m0 (.a(seq_a0_0_m0), .b(seq_a0_1_m0), .c(seq_a0_2_m0), .d(seq_a0_3_m0), 
							      .e(seq_a0_4_m0), .f(seq_a0_5_m0), .g(seq_a0_6_m0), .h(seq_a0_7_m0),
						          .i(seq_a0_8_m0), .j(8'd0), .k(8'd0), .l(8'd0),
							      .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(a0_m0));

	eight_bit_4_1_mux mux_a0_m1 (.a(seq_a0_0_m1), .b(seq_a0_1_m1), .c(seq_a0_2_m1), .d(8'd0),
								 .s0(cnt[0]), .s1(cnt[1]), .out(a0_m1));

	eight_bit_16_1_mux mux_a1_m0 (.a(seq_a1_0_m0), .b(seq_a1_1_m0), .c(seq_a1_2_m0), .d(seq_a1_3_m0), 
							      .e(seq_a1_4_m0), .f(seq_a1_5_m0), .g(seq_a1_6_m0), .h(seq_a1_7_m0),
						          .i(seq_a1_8_m0), .j(8'd0), .k(8'd0), .l(8'd0),
						    	  .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(a1_m0));
								
	eight_bit_4_1_mux mux_a1_m1 (.a(seq_a1_0_m1), .b(seq_a1_1_m1), .c(seq_a1_2_m1), .d(8'd0),
								 .s0(cnt[0]), .s1(cnt[1]), .out(a1_m1));						
							   
	eight_bit_16_1_mux mux_a2_m0 (.a(seq_a2_0_m0), .b(seq_a2_1_m0), .c(seq_a2_2_m0), .d(seq_a2_3_m0), 
							      .e(seq_a2_4_m0), .f(seq_a2_5_m0), .g(seq_a2_6_m0), .h(seq_a2_7_m0),
						          .i(seq_a2_8_m0), .j(8'd0), .k(8'd0), .l(8'd0),
							      .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(a2_m0));
								  
	eight_bit_4_1_mux mux_a2_m1 (.a(seq_a2_0_m1), .b(seq_a2_1_m1), .c(seq_a2_2_m1), .d(8'd0),
								 .s0(cnt[0]), .s1(cnt[1]), .out(a2_m1));


	eight_bit_16_1_mux mux_b0_m0 (.a(seq_b0_0_m0), .b(seq_b0_1_m0), .c(seq_b0_2_m0), .d(seq_b0_3_m0), 
							      .e(seq_b0_4_m0), .f(seq_b0_5_m0), .g(seq_b0_6_m0), .h(seq_b0_7_m0),
						          .i(seq_b0_8_m0), .j(8'd0), .k(8'd0), .l(8'd0),
							      .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(b0_m0));

	eight_bit_4_1_mux mux_b0_m1 (.a(seq_b0_0_m1), .b(seq_b0_1_m1), .c(seq_b0_2_m1), .d(8'd0),
								 .s0(cnt[0]), .s1(cnt[1]), .out(b0_m1));


	eight_bit_16_1_mux mux_b1_m0 (.a(seq_b1_0_m0), .b(seq_b1_1_m0), .c(seq_b1_2_m0), .d(seq_b1_3_m0), 
							      .e(seq_b1_4_m0), .f(seq_b1_5_m0), .g(seq_b1_6_m0), .h(seq_b1_7_m0),
						          .i(seq_b1_8_m0), .j(8'd0), .k(8'd0), .l(8'd0),
							      .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(b1_m0));

	eight_bit_4_1_mux mux_b1_m1 (.a(seq_b1_0_m1), .b(seq_b1_1_m1), .c(seq_b1_2_m1), .d(8'd0),
								 .s0(cnt[0]), .s1(cnt[1]), .out(b1_m1));
							   
	eight_bit_16_1_mux mux_b2_m0 (.a(seq_b2_0_m0), .b(seq_b2_1_m0), .c(seq_b2_2_m0), .d(seq_b2_3_m0), 
							      .e(seq_b2_4_m0), .f(seq_b2_5_m0), .g(seq_b2_6_m0), .h(seq_b2_7_m0),
						          .i(seq_b2_8_m0), .j(8'd0), .k(8'd0), .l(8'd0),
							      .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							      .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(b2_m0));

	eight_bit_4_1_mux mux_b2_m1 (.a(seq_b2_0_m1), .b(seq_b2_1_m1), .c(seq_b2_2_m1), .d(8'd0),
								 .s0(cnt[0]), .s1(cnt[1]), .out(b2_m1));		
	/* --Sequence Flow Controller End-- */
	
endmodule