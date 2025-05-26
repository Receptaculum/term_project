`timescale 1ns / 1ps

module one_by_one_systolic (
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
			
	/* --Counter 1 Declaration Start-- */

	// Wire Declaration for Counter 
	wire [7:0] cnt;
	wire [7:0] cnt_sum;	
	wire [7:0] cnt_sw;
	wire cnt_stop;

	// Counter Stop Condition (CNT >= 63) 
	assign cnt_stop = cnt >= 63;
	assign cnt_stop_clk = cnt < 64; // 1 Clock Margin
	assign clk = cnt_stop_clk & clk_in;
	
	// Instantiation for Counter
	eight_bit_register reg_cnt (.in(cnt_sum), .clk(clk), .rst(rst), .out(cnt)); // Register
	eight_bit_full_adder cnt_add (.a(cnt), .b(cnt_sw), .cin(1'b0), .sum(cnt_sum), .cout()); // Adder
	eight_bit_2_1_mux mux_sw (.a(8'd1), .b(8'd0), .s(cnt_stop), .out(cnt_sw)); // Mux (Switch)

	/* --Counter 1 Declaration End-- */		

//------------------------------------------------------------------------------------------
		
	/* --PE Declaration Start-- */
	
	// Wire Declaration for PE
	wire mode, pe_rst;	
	wire [7:0] a0, b0, c0;
	wire [7:0] out1;
	
	// Initial Condition
	assign c0 = 8'b0;
	assign mode = 1'b0;
	
	// Reset Condition
	assign pe_rst = cnt[3] & cnt[2] & cnt[1] & cnt[0];	
	
	// <PE>
	//
	//		 b_in, c_in
	//           |
	//			 V
	//         ###### <- mode, clk, pe_rst or rst
	// a_in -> # PE # -> a_out
	//         ######
	//           |
	//			 V
	//		b_out, c_out
	
	
	// <Systolic Array>
	//
 	//	    b0, c0    
	//		  |       
	//        V 
	// a0 ->  0 
	//		  |	
	//        V 
	//		 out1 

	
	// PE Instantiation
	processing_element pe0 (.clk(clk), .rst(pe_rst | rst), .mode(mode),
							.a_in(a0), .b_in(b0), .c_in(c0),
							.a_out(), .b_out(), .c_out(out1));
														
	/* --PE Declaration End-- */

//------------------------------------------------------------------------------------------

	/* --Memory Declaration Start-- */

	// <Memory>
	//
	//		 out1    
	//		  |         
	//        V        
	// 	   seq1(o11) <-- out_clk_post
	//   	  |         		 
	//  	  |          
	//     seq2(o10) <-- out_clk_post
	//   	  |        
	//  	  |       
	//     seq3(o01) <-- out_clk_post
	//   	  |     
	//   	  |     	
	//     seq4(o00) <-- out_clk_post

	// Wire Declaration
	wire [7:0] seq_out_1, seq_out_2, seq_out_3, seq_out_4;
	wire out_clk_pre, out_clk_post;
	
	// Hazard Remove
	assign out_clk_pre = cnt[3] & !cnt[2] & cnt[1] & !cnt[0];
	one_bit_register haz_rm_out_clk (.in(out_clk_pre), .clk(clk), .rst(rst), .out(out_clk_post));

	// Memory Instantiation
	eight_bit_register seq1 (.in(out1), .clk(out_clk_post), .rst(rst), .out(seq_out_1));
	eight_bit_register seq2 (.in(seq_out_1), .clk(out_clk_post), .rst(rst), .out(seq_out_2));
	eight_bit_register seq3 (.in(seq_out_2), .clk(out_clk_post), .rst(rst), .out(seq_out_3));
	eight_bit_register seq4 (.in(seq_out_3), .clk(out_clk_post), .rst(rst), .out(seq_out_4));
	
	// Wiring between reg and out
	assign o00 = seq_out_4;
	assign o01 = seq_out_3;
	assign o10 = seq_out_2;
	assign o11 = seq_out_1;

	/* --Memory Declaration End-- */

//------------------------------------------------------------------------------------------

	/* --Sequence Declaration Start-- */
	
	// Wire Declaration for Sequences (9 Clock)
	wire [7:0] seq_a0_1_0, seq_a0_1_1, seq_a0_1_2; 
	wire [7:0] seq_a0_1_3, seq_a0_1_4, seq_a0_1_5; 
	wire [7:0] seq_a0_1_6, seq_a0_1_7, seq_a0_1_8; 

	wire [7:0] seq_a0_2_0, seq_a0_2_1, seq_a0_2_2; 
	wire [7:0] seq_a0_2_3, seq_a0_2_4, seq_a0_2_5; 
	wire [7:0] seq_a0_2_6, seq_a0_2_7, seq_a0_2_8; 	

	wire [7:0] seq_a0_3_0, seq_a0_3_1, seq_a0_3_2; 
	wire [7:0] seq_a0_3_3, seq_a0_3_4, seq_a0_3_5; 
	wire [7:0] seq_a0_3_6, seq_a0_3_7, seq_a0_3_8; 		

	wire [7:0] seq_a0_4_0, seq_a0_4_1, seq_a0_4_2; 
	wire [7:0] seq_a0_4_3, seq_a0_4_4, seq_a0_4_5; 
	wire [7:0] seq_a0_4_6, seq_a0_4_7, seq_a0_4_8;

	wire [7:0] seq_b0_0, seq_b0_1, seq_b0_2; 
	wire [7:0] seq_b0_3, seq_b0_4, seq_b0_5; 
	wire [7:0] seq_b0_6, seq_b0_7, seq_b0_8; 
	

	// Sequence Allocation
	assign {seq_a0_1_0, seq_a0_1_1, seq_a0_1_2, seq_a0_1_3, seq_a0_1_4, seq_a0_1_5, seq_a0_1_6, seq_a0_1_7, seq_a0_1_8}
	= {i00, i10, i20, i01, i11, i21, i02, i12, i22};
	
	assign {seq_a0_2_0, seq_a0_2_1, seq_a0_2_2, seq_a0_2_3, seq_a0_2_4, seq_a0_2_5, seq_a0_2_6, seq_a0_2_7, seq_a0_2_8}
	= {i01, i11, i21, i02, i12, i22, i03, i13, i23};
	
	assign {seq_a0_3_0, seq_a0_3_1, seq_a0_3_2, seq_a0_3_3, seq_a0_3_4, seq_a0_3_5, seq_a0_3_6, seq_a0_3_7, seq_a0_3_8}
	= {i10, i20, i30, i11, i21, i31, i12, i22, i32};

	assign {seq_a0_4_0, seq_a0_4_1, seq_a0_4_2, seq_a0_4_3, seq_a0_4_4, seq_a0_4_5, seq_a0_4_6, seq_a0_4_7, seq_a0_4_8}
	= {i11, i21, i31, i12, i22, i32, i13, i23, i33};	

	assign {seq_b0_0, seq_b0_1, seq_b0_2, seq_b0_3, seq_b0_4, seq_b0_5, seq_b0_6, seq_b0_7, seq_b0_8}
	= {f22, f12, f02, f21, f11, f01, f20, f10, f00};

	/* --Sequence Declaration End-- */

	//------------------------------------------------------------------------------------------	
	
	/* --Sequence Flow Controller Start-- */
	
	// Wire Declaration for Mux Outputs
	wire [7:0] a0_1_out, a0_2_out, a0_3_out, a0_4_out;
	
	eight_bit_16_1_mux mux_a0_1 (.a(seq_a0_1_0), .b(seq_a0_1_1), .c(seq_a0_1_2), .d(seq_a0_1_3), 
							     .e(seq_a0_1_4), .f(seq_a0_1_5), .g(seq_a0_1_6), .h(seq_a0_1_7),
						         .i(seq_a0_1_8), .j(8'd0), .k(8'd0), .l(8'd0),
  	  						     .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							     .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(a0_1_out));

	eight_bit_16_1_mux mux_a0_2 (.a(seq_a0_2_0), .b(seq_a0_2_1), .c(seq_a0_2_2), .d(seq_a0_2_3), 
							     .e(seq_a0_2_4), .f(seq_a0_2_5), .g(seq_a0_2_6), .h(seq_a0_2_7),
						         .i(seq_a0_2_8), .j(8'd0), .k(8'd0), .l(8'd0),
  	  						     .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							     .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(a0_2_out));
								 
	eight_bit_16_1_mux mux_a0_3 (.a(seq_a0_3_0), .b(seq_a0_3_1), .c(seq_a0_3_2), .d(seq_a0_3_3), 
							     .e(seq_a0_3_4), .f(seq_a0_3_5), .g(seq_a0_3_6), .h(seq_a0_3_7),
						         .i(seq_a0_3_8), .j(8'd0), .k(8'd0), .l(8'd0),
  	  						     .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							     .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(a0_3_out));

	eight_bit_16_1_mux mux_a0_4 (.a(seq_a0_4_0), .b(seq_a0_4_1), .c(seq_a0_4_2), .d(seq_a0_4_3), 
							     .e(seq_a0_4_4), .f(seq_a0_4_5), .g(seq_a0_4_6), .h(seq_a0_4_7),
						         .i(seq_a0_4_8), .j(8'd0), .k(8'd0), .l(8'd0),
  	  						     .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							     .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(a0_4_out));

	eight_bit_4_1_mux mux_select (.a(a0_1_out), .b(a0_2_out), .c(a0_3_out), .d(a0_4_out), .s0(cnt[4]), .s1(cnt[5]), .out(a0));

	eight_bit_16_1_mux mux_b0 (.a(seq_b0_0), .b(seq_b0_1), .c(seq_b0_2), .d(seq_b0_3), 
							   .e(seq_b0_4), .f(seq_b0_5), .g(seq_b0_6), .h(seq_b0_7),
						       .i(seq_b0_8), .j(8'd0), .k(8'd0), .l(8'd0),
  	  						   .m(8'd0), .n(8'd0), .o(8'd0), .p(8'd0), 
							   .s0(cnt[0]), .s1(cnt[1]), .s2(cnt[2]), .s3(cnt[3]), .out(b0));
							   
	/* --Sequence Flow Controller End-- */
	
endmodule	