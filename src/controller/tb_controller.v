`timescale 1ns / 1ps

module tb_controller;

    reg clk, rst;
    wire rst_mem, rst_pe, rst_3b3, rst_2b2, rst_disp;
    wire [2:0] state;

    controller cont (
        .clk(clk), .rst(rst),
        .rst_mem(rst_mem), .rst_pe(rst_pe),
        .rst_3b3(rst_3b3), .rst_2b2(rst_2b2),
        .rst_disp(rst_disp), .state(state)
    );

    // Clock generator: 100 MHz (10ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    // Reset sequence
    initial begin
        rst = 1;
        #5 rst = 0;
        #500 rst = 1;
    end

    // Monitor state changes
    initial begin
        $display("Time(ns)\tState");
        $monitor("%0t\t\t%d", $time, state);
    end

endmodule