`timescale 1ns / 1ps

module tb_memory;

    reg clk;
    reg rst;

    wire [7:0] input_data0, input_data1, input_data2, input_data3;
    wire [7:0] input_data4, input_data5, input_data6, input_data7;
    wire [7:0] input_data8, input_data9, input_data10, input_data11;
    wire [7:0] input_data12, input_data13, input_data14, input_data15;

    wire [7:0] filter_data0, filter_data1, filter_data2;
    wire [7:0] filter_data3, filter_data4, filter_data5;
    wire [7:0] filter_data6, filter_data7, filter_data8;

    memory uut (
        .clk(clk),
        .rst(rst),
        .input_data0(input_data0), .input_data1(input_data1),
        .input_data2(input_data2), .input_data3(input_data3),
        .input_data4(input_data4), .input_data5(input_data5),
        .input_data6(input_data6), .input_data7(input_data7),
        .input_data8(input_data8), .input_data9(input_data9),
        .input_data10(input_data10), .input_data11(input_data11),
        .input_data12(input_data12), .input_data13(input_data13),
        .input_data14(input_data14), .input_data15(input_data15),
        .filter_data0(filter_data0), .filter_data1(filter_data1),
        .filter_data2(filter_data2), .filter_data3(filter_data3),
        .filter_data4(filter_data4), .filter_data5(filter_data5),
        .filter_data6(filter_data6), .filter_data7(filter_data7),
        .filter_data8(filter_data8)
    );

    initial clk = 0;
    always #5 clk = ~clk; 

    initial begin
        rst = 1;
        #10;
        rst = 0;
        #100;

        $finish;
    end

endmodule