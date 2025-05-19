`timescale 1ns / 1ps
module display_for_testbench_tb();

    reg clk_1hz;
    reg clk_1000hz;
    reg resetn;
    reg [7:0] c9_11, c9_12, c9_21, c9_22, c4_11, c4_12, c4_21, c4_22;
    wire [2:0] digit;
    wire [7:0] seg_data;
    wire [3:0] state;
    wire [3:0] next_state;
    wire [1:0] i;
    wire [11:0] c9_11_d, c9_12_d, c9_21_d, c9_22_d;
    wire [11:0] c4_11_d, c4_12_d, c4_21_d, c4_22_d;
    wire [3:0] decoder_f_in, decoder_s_in, decoder_t_in;
    
    display_for_testbench dut (clk_1hz, clk_1000hz, resetn,
                 c9_11, c9_12, c9_21, c9_22, c4_11, c4_12, c4_21, c4_22, 
                 digit, seg_data, state, next_state,
                 i, 
                 c9_11_d, c9_12_d, c9_21_d, c9_22_d, c4_11_d, c4_12_d, c4_21_d, c4_22_d,
                 decoder_f_in, decoder_s_in, decoder_t_in);
    
    initial begin
        clk_1hz = 0;
        clk_1000hz = 0;
        resetn = 0;
        c9_11 = 8'b0000_0001;
        c9_12 = 8'b0000_0010;
        c9_21 = 8'b0000_0100;
        c9_22 = 8'b0000_1000;
        c4_11 = 8'b0001_0000;
        c4_12 = 8'b0010_0000;
        c4_21 = 8'b0100_0000;
        c4_22 = 8'b1000_0000;
    end
    
    always #1000 clk_1hz = ~clk_1hz;
    always #10 clk_1000hz = ~clk_1000hz;
    
    initial begin
        #50 resetn = 1;
        #50 resetn = 0;
        #50 resetn = 1;
    end

endmodule