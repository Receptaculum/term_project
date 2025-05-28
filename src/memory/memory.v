`timescale 1ns / 1ps
module memory(
    input clk,
    input rst,
    output [7:0] input_data0,
    output [7:0] input_data1,
    output [7:0] input_data2,
    output [7:0] input_data3,
    output [7:0] input_data4,
    output [7:0] input_data5,
    output [7:0] input_data6,
    output [7:0] input_data7,
    output [7:0] input_data8,
    output [7:0] input_data9,
    output [7:0] input_data10,
    output [7:0] input_data11,
    output [7:0] input_data12,
    output [7:0] input_data13,
    output [7:0] input_data14,
    output [7:0] input_data15,
    output [7:0] filter_data0,
    output [7:0] filter_data1,
    output [7:0] filter_data2,
    output [7:0] filter_data3,
    output [7:0] filter_data4,
    output [7:0] filter_data5,
    output [7:0] filter_data6,
    output [7:0] filter_data7,
    output [7:0] filter_data8
);

    // 4x4 입력 고정값
    wire [7:0] in0 = 8'd145,  in1 = 8'd37,  in2 = 8'd19,  in3 = 8'd86;
    wire [7:0] in4 = 8'd190,  in5 = 8'd227,  in6 = 8'd126,  in7 = 8'd234;
    wire [7:0] in8 = 8'd232,  in9 = 8'd117, in10 = 8'd92, in11 = 8'd232;
    wire [7:0] in12 = 8'd128, in13 = 8'd105, in14 = 8'd153, in15 = 8'd204;

    // 3x3 필터 고정값
    wire [7:0] f0 = 8'd18, f1 = 8'd116, f2 = 8'd231;
    wire [7:0] f3 = 8'd139, f4 = 8'd13, f5 = 8'd188;
    wire [7:0] f6 = 8'd51, f7 = 8'd132, f8 = 8'd142;
	

    eight_bit_register r0 (.clk(clk), .rst(rst), .in(in0),  .out(input_data0));
    eight_bit_register r1 (.clk(clk), .rst(rst), .in(in1),  .out(input_data1));
    eight_bit_register r2 (.clk(clk), .rst(rst), .in(in2),  .out(input_data2));
    eight_bit_register r3 (.clk(clk), .rst(rst), .in(in3),  .out(input_data3));
    eight_bit_register r4 (.clk(clk), .rst(rst), .in(in4),  .out(input_data4));
    eight_bit_register r5 (.clk(clk), .rst(rst), .in(in5),  .out(input_data5));
    eight_bit_register r6 (.clk(clk), .rst(rst), .in(in6),  .out(input_data6));
    eight_bit_register r7 (.clk(clk), .rst(rst), .in(in7),  .out(input_data7));
    eight_bit_register r8 (.clk(clk), .rst(rst), .in(in8),  .out(input_data8));
    eight_bit_register r9 (.clk(clk), .rst(rst), .in(in9),  .out(input_data9));
    eight_bit_register r10(.clk(clk), .rst(rst), .in(in10), .out(input_data10));
    eight_bit_register r11(.clk(clk), .rst(rst), .in(in11), .out(input_data11));
    eight_bit_register r12(.clk(clk), .rst(rst), .in(in12), .out(input_data12));
    eight_bit_register r13(.clk(clk), .rst(rst), .in(in13), .out(input_data13));
    eight_bit_register r14(.clk(clk), .rst(rst), .in(in14), .out(input_data14));
    eight_bit_register r15(.clk(clk), .rst(rst), .in(in15), .out(input_data15));

    eight_bit_register f_reg0 (.clk(clk), .rst(rst), .in(f0), .out(filter_data0));
    eight_bit_register f_reg1 (.clk(clk), .rst(rst), .in(f1), .out(filter_data1));
    eight_bit_register f_reg2 (.clk(clk), .rst(rst), .in(f2), .out(filter_data2));
    eight_bit_register f_reg3 (.clk(clk), .rst(rst), .in(f3), .out(filter_data3));
    eight_bit_register f_reg4 (.clk(clk), .rst(rst), .in(f4), .out(filter_data4));
    eight_bit_register f_reg5 (.clk(clk), .rst(rst), .in(f5), .out(filter_data5));
    eight_bit_register f_reg6 (.clk(clk), .rst(rst), .in(f6), .out(filter_data6));
    eight_bit_register f_reg7 (.clk(clk), .rst(rst), .in(f7), .out(filter_data7));
    eight_bit_register f_reg8 (.clk(clk), .rst(rst), .in(f8), .out(filter_data8));

endmodule
