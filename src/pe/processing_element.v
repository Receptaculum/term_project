`timescale 1ns / 1ps

module processing_element (clk, rst, mode, a_in, b_in, c_in, a_out, b_out, c_out);

	// I/O Declaration
    input clk, rst, mode;
    input [7:0] a_in, b_in, c_in;
    output [7:0] a_out, b_out, c_out;
	
	
	/* --Mode Selector Start-- */
	
	// Mode 0 (mode=0) : update the output register with acc_post 
	// Mode 1 (mode=1) : update the output register with c_in which is the external data
	
	// Selection Wire
	wire [7:0] sel_sig; 

	// ACC Wire Declaration
    wire [7:0] acc_pre;
	wire [7:0] acc_post;

	// Module Instantiation
	eight_bit_2_1_mux selector (.a(acc_post), .b(c_in), .s(mode), .out(sel_sig));
	eight_bit_register cout_reg (.in(sel_sig), .clk(clk), .rst(rst), .out(c_out));
	
	/* --Mode Selector End-- */

	//------------------------------------------------------------------------------------------	
    
	/* --I/O Propagator Start-- */
	
	// For a_out and b_out
	eight_bit_register reg_a_out (.in(a_in), .clk(clk), .rst(rst), .out(a_out));
	eight_bit_register reg_b_out (.in(b_in), .clk(clk), .rst(rst), .out(b_out));
	
	/* --I/O Propagator End-- */
	
	//------------------------------------------------------------------------------------------	
	
	/* --MAC Operator Start-- */
	
	// Wire Declaration for Shift Operation
	wire [7:0] shift_0, shift_1, shift_2, shift_3, shift_4, shift_5, shift_6, shift_7;
	
	// Shift Operation
	assign shift_0 = {a_in[7], a_in[6], a_in[5], a_in[4], a_in[3], a_in[2], a_in[1], a_in[0]};
	assign shift_1 = {a_in[6], a_in[5], a_in[4], a_in[3], a_in[2], a_in[1], a_in[0], 1'b0};
	assign shift_2 = {a_in[5], a_in[4], a_in[3], a_in[2], a_in[1], a_in[0], 1'b0, 1'b0};
	assign shift_3 = {a_in[4], a_in[3], a_in[2], a_in[1], a_in[0], 1'b0, 1'b0, 1'b0};
	assign shift_4 = {a_in[3], a_in[2], a_in[1], a_in[0], 1'b0, 1'b0, 1'b0, 1'b0};
	assign shift_5 = {a_in[2], a_in[1], a_in[0], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
	assign shift_6 = {a_in[1], a_in[0], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};	
	assign shift_7 = {a_in[0], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};	
	
	// Operand Wire Declaration
	wire [7:0] operand_val_0_pre, operand_val_1_pre, operand_val_2_pre, operand_val_3_pre;
	wire [7:0] operand_val_4_pre, operand_val_5_pre, operand_val_6_pre, operand_val_7_pre;
	wire [7:0] operand_val_0_post, operand_val_1_post, operand_val_2_post, operand_val_3_post;
	wire [7:0] operand_val_4_post, operand_val_5_post, operand_val_6_post, operand_val_7_post;	
	
	// Value Selector
	eight_bit_2_1_mux mux_0 (.a(8'd0), .b(shift_0), .s(b_in[0]), .out(operand_val_0_pre));
	eight_bit_2_1_mux mux_1 (.a(8'd0), .b(shift_1), .s(b_in[1]), .out(operand_val_1_pre));
	eight_bit_2_1_mux mux_2 (.a(8'd0), .b(shift_2), .s(b_in[2]), .out(operand_val_2_pre));
	eight_bit_2_1_mux mux_3 (.a(8'd0), .b(shift_3), .s(b_in[3]), .out(operand_val_3_pre));
	eight_bit_2_1_mux mux_4 (.a(8'd0), .b(shift_4), .s(b_in[4]), .out(operand_val_4_pre));
	eight_bit_2_1_mux mux_5 (.a(8'd0), .b(shift_5), .s(b_in[5]), .out(operand_val_5_pre));
	eight_bit_2_1_mux mux_6 (.a(8'd0), .b(shift_6), .s(b_in[6]), .out(operand_val_6_pre));
	eight_bit_2_1_mux mux_7 (.a(8'd0), .b(shift_7), .s(b_in[7]), .out(operand_val_7_pre));
	
	// Reg for Input Data
	eight_bit_register reg_op_0 (.in(operand_val_0_pre), .clk(clk), .rst(rst), .out(operand_val_0_post));
	eight_bit_register reg_op_1 (.in(operand_val_1_pre), .clk(clk), .rst(rst), .out(operand_val_1_post));
	eight_bit_register reg_op_2 (.in(operand_val_2_pre), .clk(clk), .rst(rst), .out(operand_val_2_post));
	eight_bit_register reg_op_3 (.in(operand_val_3_pre), .clk(clk), .rst(rst), .out(operand_val_3_post));
	eight_bit_register reg_op_4 (.in(operand_val_4_pre), .clk(clk), .rst(rst), .out(operand_val_4_post));
	eight_bit_register reg_op_5 (.in(operand_val_5_pre), .clk(clk), .rst(rst), .out(operand_val_5_post));
	eight_bit_register reg_op_6 (.in(operand_val_6_pre), .clk(clk), .rst(rst), .out(operand_val_6_post));
	eight_bit_register reg_op_7 (.in(operand_val_7_pre), .clk(clk), .rst(rst), .out(operand_val_7_post));

	// SUM Wire Declcration
	wire [7:0] sum_0;
	wire [7:0] sum_1;
	wire [7:0] sum_2;
	wire [7:0] sum_3;
	wire [7:0] sum_4;
	wire [7:0] sum_5;
	wire [7:0] sum_6;
	
	// Multiplication Process
    eight_bit_full_adder fa0 (.a(operand_val_1_post), .b(operand_val_0_post), .cin(1'b0), .sum(sum_0), .cout());
    eight_bit_full_adder fa1 (.a(operand_val_2_post), .b(sum_0), .cin(1'b0), .sum(sum_1), .cout());
    eight_bit_full_adder fa2 (.a(operand_val_3_post), .b(sum_1), .cin(1'b0), .sum(sum_2), .cout());
    eight_bit_full_adder fa3 (.a(operand_val_4_post), .b(sum_2), .cin(1'b0), .sum(sum_3), .cout());
    eight_bit_full_adder fa4 (.a(operand_val_5_post), .b(sum_3), .cin(1'b0), .sum(sum_4), .cout());
    eight_bit_full_adder fa5 (.a(operand_val_6_post), .b(sum_4), .cin(1'b0), .sum(sum_5), .cout());
    eight_bit_full_adder fa6 (.a(operand_val_7_post), .b(sum_5), .cin(1'b0), .sum(sum_6), .cout());

	// Accumulation process
	eight_bit_full_adder fa_acc (.a(acc_post), .b(sum_6), .cin(1'b0), .sum(acc_pre), .cout());
	
	// Reg for Accumulation Data
	eight_bit_register reg_acc (.in(acc_pre), .clk(clk), .rst(rst), .out(acc_post));

	/* --MAC Operator End-- */

endmodule