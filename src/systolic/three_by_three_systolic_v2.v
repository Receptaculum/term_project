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
	
	/* --I/O Declaration End-- */
	
	//------------------------------------------------------------------------------------------
	
	/* --PE Declaration Start-- */
	
	// Wire Declaration for PE
	wire mode;	
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
	processing_element pe0 (.clk(clk), .rst(rst), .mode(mode),
							.a_in(a0), .b_in(b0), .c_in(c0),
							.a_out(w01), .b_out(w03), .c_out(c3));
							
	processing_element pe1 (.clk(clk), .rst(rst), .mode(mode),
							.a_in(w01), .b_in(b1), .c_in(c1),
							.a_out(w12), .b_out(w14), .c_out(c4));
							
	processing_element pe2 (.clk(clk), .rst(rst), .mode(mode),
							.a_in(w12), .b_in(b2), .c_in(c2),
							.a_out(), .b_out(w25), .c_out(c5));
							
	processing_element pe3 (.clk(clk), .rst(rst), .mode(mode),
							.a_in(a1), .b_in(w03), .c_in(c3),
							.a_out(w34), .b_out(w36), .c_out(c6));

	processing_element pe4 (.clk(clk), .rst(rst), .mode(mode),
							.a_in(w34), .b_in(w14), .c_in(c4),
							.a_out(w45), .b_out(w47), .c_out(c7));
							
	processing_element pe5 (.clk(clk), .rst(rst), .mode(mode),
							.a_in(w45), .b_in(w25), .c_in(c5),
							.a_out(), .b_out(w58), .c_out(c8));
							
	processing_element pe6 (.clk(clk), .rst(rst), .mode(mode),
							.a_in(a2), .b_in(w36), .c_in(c6),
							.a_out(w67), .b_out(), .c_out(out1));
							
	processing_element pe7 (.clk(clk), .rst(rst), .mode(mode),
							.a_in(w67), .b_in(w47), .c_in(c7),
							.a_out(w78), .b_out(), .c_out(out2));
		
	processing_element pe8 (.clk(clk), .rst(rst), .mode(mode),
							.a_in(w78), .b_in(w58), .c_in(c8),
						    .a_out(), .b_out(), .c_out(out3));

	/* --PE Declaration End-- */



endmodule