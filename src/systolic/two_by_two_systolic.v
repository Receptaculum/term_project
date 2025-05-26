`timescale 1ns / 1ps

module two_by_two_systolic (
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
	
	/* --I/O Declaration End-- */
	
	//------------------------------------------------------------------------------------------
	
	/* --PE Declaration Start-- */
	
	// Wire Declaration for PE
	wire mode;	
	wire [7:0] a0, a1;
	wire [7:0] b0, b1;
	wire [7:0] w01, w02, w13, w23;
	wire [7:0] c0, c1, c2, c3;
	wire [7:0] out1, out2;
	
	assign c0 = 8'b0;
	assign c1 = 8'b0;	
	
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
 	//	    b0, c0      b1, c1	    
	//		  |           |			 
	//        V           V			  
	// a0 ->  0 -- w01 -- 1	
	//   	  |           |			 
	// 	   w02, c2     w13, c3	   
	//  	  |           |			 
	// a1 ->  2 -- w23 -- 3 
	//		  |			  |			
	//        V           V        
	//		 out1        out2

	
	// PE Instantiation
	processing_element pe0 (.clk(clk), .rst(rst), .mode(mode),
							.a_in(a0), .b_in(b0), .c_in(c0),
							.a_out(w01), .b_out(w02), .c_out(c2));
							
	processing_element pe1 (.clk(clk), .rst(rst), .mode(mode),
							.a_in(w01), .b_in(b1), .c_in(c1),
							.a_out(), .b_out(w13), .c_out(c3));
							
	processing_element pe2 (.clk(clk), .rst(rst), .mode(mode),
							.a_in(a1), .b_in(w02), .c_in(c2),
							.a_out(w23), .b_out(), .c_out(out1));
							
	processing_element pe3 (.clk(clk), .rst(rst), .mode(mode),
							.a_in(w23), .b_in(w13), .c_in(c3),
							.a_out(), .b_out(), .c_out(out2));

	/* --PE Declaration End-- */

	//------------------------------------------------------------------------------------------

	/* --Memory Declaration Start-- */
	
	// <Memory>
	//
	//		 out1         out2    
	//		  |            |
	//        V            V
	// 	    mem00(o00)   mem01(o01)     
	//   	  |            |	      
	// 	   	 mw1		  mw2	     
	//  	  |            |		   
	//      mem10(o10)   mem11(o11)	     
	//   	  |            |           
	// 	     mw3          mw4        


	// Wire Declaration
	wire [7:0] mw1, mw2;
	wire [7:0] mw3, mw4;
	
	// Memory Instantiation
	eight_bit_register mem00 (.in(out1), .clk(clk), .rst(rst), .out(mw1));
	eight_bit_register mem10 (.in(mw1), .clk(clk), .rst(rst), .out(mw3));
	
	eight_bit_register mem01 (.in(out2), .clk(clk), .rst(rst), .out(mw2));
	eight_bit_register mem11 (.in(mw2), .clk(clk), .rst(rst), .out(mw4));
	
	
	// Wiring between reg and out
	assign o00 = mw1;
	assign o01 = mw2;
	assign o10 = mw3;
	assign o11 = mw4;

	/* --Memory Declaration End-- */

	//------------------------------------------------------------------------------------------
	
	/* --Sequence Declaration Start-- */
	
	// Wire Declaration for Sequences (13 Clock)
	wire [7:0] seq_a0_0, seq_a0_1, seq_a0_2, seq_a0_3;
	wire [7:0] seq_a0_4, seq_a0_5, seq_a0_6, seq_a0_7;
	wire [7:0] seq_a0_8, seq_a0_9, seq_a0_10, seq_a0_11;
	wire [7:0] seq_a0_12;

	wire [7:0] seq_a1_0, seq_a1_1, seq_a1_2, seq_a1_3;
	wire [7:0] seq_a1_4, seq_a1_5, seq_a1_6, seq_a1_7;
	wire [7:0] seq_a1_8, seq_a1_9, seq_a1_10, seq_a1_11;
	wire [7:0] seq_a1_12;

	wire [7:0] seq_b0_0, seq_b0_1, seq_b0_2, seq_b0_3;
	wire [7:0] seq_b0_4, seq_b0_5, seq_b0_6, seq_b0_7;
	wire [7:0] seq_b0_8, seq_b0_9, seq_b0_10, seq_b0_11;
	wire [7:0] seq_b0_12;
	
	wire [7:0] seq_b1_0, seq_b1_1, seq_b1_2, seq_b1_3;
	wire [7:0] seq_b1_4, seq_b1_5, seq_b1_6, seq_b1_7;
	wire [7:0] seq_b1_8, seq_b1_9, seq_b1_10, seq_b1_11;
	wire [7:0] seq_b1_12;


	// Sequence Allocation
	assign {seq_a0_0, seq_a0_1, seq_a0_2, seq_a0_3, seq_a0_4, seq_a0_5, seq_a0_6, seq_a0_7, seq_a0_8, seq_a0_9, seq_a0_10, seq_a0_11, seq_a0_12} 
	= {i00, i10, i20, i01, i11, i21, i02, i12, i22, i03, i13, i23, 8'b00000000};
	
	assign {seq_a1_0, seq_a1_1, seq_a1_2, seq_a1_3, seq_a1_4, seq_a1_5, seq_a1_6, seq_a1_7, seq_a1_8, seq_a1_9, seq_a1_10, seq_a1_11, seq_a1_12}
	= {8'b00000000, i10, i20, i30, i11, i21, i31, i12, i22, i32, i13, i23, i33};
	
	assign {seq_b0_0, seq_b0_1, seq_b0_2, seq_b0_3, seq_b0_4, seq_b0_5, seq_b0_6, seq_b0_7, seq_b0_8, seq_b0_9, seq_b0_10, seq_b0_11, seq_b0_12} 
	= {f22, f12, f02, f21, f11, f01, f20, f10, f00, 8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000};

	assign {seq_b1_0, seq_b1_1, seq_b1_2, seq_b1_3, seq_b1_4, seq_b1_5, seq_b1_6, seq_b1_7, seq_b1_8, seq_b1_9, seq_b1_10, seq_b1_11, seq_b1_12}
	= {8'b00000000, 8'b00000000, 8'b00000000, 8'b00000000, f22, f12, f02, f21, f11, f01, f20, f10, f00};
	
	/* --Sequence Declaration End-- */
	
	//------------------------------------------------------------------------------------------

	/* --Counter 1 Declaration Start-- */
	// Counter 1 is utilized for MUX manipulation

	// Wire Declaration	
	wire [3:0] cnt;
	wire [3:0] cnt_sum;	
	wire [3:0] cnt_sw;
	wire cnt_stop_pre;

	// Counter Stop Condition (CNT >= 15) 
	assign cnt_stop_pre = cnt >= 15;
		
	// Instantiation for Counter 1
	four_bit_register reg_cnt (.in(cnt_sum), .clk(clk), .rst(rst), .out(cnt)); // Register
	four_bit_full_adder cnt_add (.a(cnt), .b(cnt_sw), .cin(1'b0), .sum(cnt_sum), .cout()); // Adder
	four_bit_2_1_mux mux_sw (.a(4'd1), .b(4'd0), .s(cnt_stop_pre), .out(cnt_sw)); // Mux (Switch)

	/* --Counter 1 Declaration End-- */	

	//------------------------------------------------------------------------------------------

	/* --Delay Declaration Start-- */	
	// This is a delay for timing between counter1 and counter2

	// Wire Declaration
	wire cnt_stop_post;
	
	// Delay Operation
    one_bit_register delay_1 (.in(cnt_stop_pre), .clk(clk), .rst(rst), .out(cnt_stop_post));
	
	// Change the operation mode of PE when cnt_stop condition is satisfied
	assign mode = cnt_stop_post;
	
	/* --Delay Declaration End-- */			

	//------------------------------------------------------------------------------------------	
	
	/* --Counter 2 Declaration Start-- */
	// Counter 2 is utilized for main clock disable condition

	// Wire Declaration	
	wire [3:0] cnt_clk;
	wire [3:0] cnt_sum_clk;
	wire [3:0] cnt_sw_clk;
	wire cnt_stop_clk;

	// Disable main clock when operation is complete
	assign cnt_stop_clk = !(cnt_clk >= 2);
	assign clk = cnt_stop_clk & clk_in; 

	// Instantiation for Counter 2
	four_bit_register reg_cnt_clk (.in(cnt_sum_clk), .clk(clk), .rst(rst), .out(cnt_clk)); // Register
	four_bit_full_adder cnt_add_clk (.a(cnt_clk), .b(cnt_sw_clk), .cin(1'b0), .sum(cnt_sum_clk), .cout()); // Adder
	four_bit_2_1_mux mux_sw_clk (.a(4'd0), .b(4'd1), .s(cnt_stop_post), .out(cnt_sw_clk)); // Mux (Switch)
	
	/* --Counter 2 Declaration End-- */		

	//------------------------------------------------------------------------------------------

	/* --Sequence Flow Controller Start-- */
	
	// Wire Declaration for Mux Selection
	wire sel0, sel1, sel2, sel3;	
	
	// Mux Instantiation for Stop Configuration
	one_bit_2_1_mux select_c0 (.a(cnt[0]), .b(1'b1), .s(cnt_stop_pre), .out(sel0));
	one_bit_2_1_mux select_c1 (.a(cnt[1]), .b(1'b1), .s(cnt_stop_pre), .out(sel1));
	one_bit_2_1_mux select_c2 (.a(cnt[2]), .b(1'b1), .s(cnt_stop_pre), .out(sel2));
	one_bit_2_1_mux select_c3 (.a(cnt[3]), .b(1'b1), .s(cnt_stop_pre), .out(sel3));
	
	// Mux Instantiation for Sequence Selction
	eight_bit_16_1_mux mux_a0 (.a(seq_a0_0), .b(seq_a0_1), .c(seq_a0_2), .d(seq_a0_3), 
							   .e(seq_a0_4), .f(seq_a0_5), .g(seq_a0_6), .h(seq_a0_7),
						       .i(seq_a0_8), .j(seq_a0_9), .k(seq_a0_10), .l(seq_a0_11),
							   .m(seq_a0_12), .n(8'd0), .o(8'd0), .p(8'd0), 
							   .s0(sel0), .s1(sel1), .s2(sel2), .s3(sel3), .out(a0));

	eight_bit_16_1_mux mux_a1 (.a(seq_a1_0), .b(seq_a1_1), .c(seq_a1_2), .d(seq_a1_3), 
							   .e(seq_a1_4), .f(seq_a1_5), .g(seq_a1_6), .h(seq_a1_7),
						       .i(seq_a1_8), .j(seq_a1_9), .k(seq_a1_10), .l(seq_a1_11),
							   .m(seq_a1_12), .n(8'd0), .o(8'd0), .p(8'd0), 
							   .s0(sel0), .s1(sel1), .s2(sel2), .s3(sel3), .out(a1));	
							   
	eight_bit_16_1_mux mux_b0 (.a(seq_b0_0), .b(seq_b0_1), .c(seq_b0_2), .d(seq_b0_3), 
							   .e(seq_b0_4), .f(seq_b0_5), .g(seq_b0_6), .h(seq_b0_7),
						       .i(seq_b0_8), .j(seq_b0_9), .k(seq_b0_10), .l(seq_b0_11),
							   .m(seq_b0_12), .n(8'd0), .o(8'd0), .p(8'd0), 
							   .s0(sel0), .s1(sel1), .s2(sel2), .s3(sel3), .out(b0));

	eight_bit_16_1_mux mux_b1 (.a(seq_b1_0), .b(seq_b1_1), .c(seq_b1_2), .d(seq_b1_3), 
							   .e(seq_b1_4), .f(seq_b1_5), .g(seq_b1_6), .h(seq_b1_7),
						       .i(seq_b1_8), .j(seq_b1_9), .k(seq_b1_10), .l(seq_b1_11),
							   .m(seq_b1_12), .n(8'd0), .o(8'd0), .p(8'd0), 
							   .s0(sel0), .s1(sel1), .s2(sel2), .s3(sel3), .out(b1));
							   
	/* --Sequence Flow Controller End-- */
	
endmodule