// `timescale 1ns / 1ps

module tb_processing_element;
    wire [7:0] a_out, b_out, c_out;
    reg [7:0] a_in, b_in, c_in;
    reg clk, rst, en;

    processing_element pe (.clk(clk), .rst(rst), .en(en), .a_in(a_in), .b_in(b_in), .c_in(c_in), .a_out(a_out), .b_out(b_out), .c_out(c_out));

	initial forever begin

	
	#5 clk = ~clk;
	end

    initial begin	
	c_in <= 8'd4;
	en <= 1'b0;
	a_in <= 8'b00000000;
	b_in <= 8'b00000000;
	
    clk <= 0;
    rst <= 1;
    #5
	
	rst <= 0;
	#10
	
	a_in <= 8'b01010101;
	b_in <= 8'b00110011;
	#10
	
	a_in <= 8'b00010010;
	b_in <= 8'b00101110;
	#10
	
	a_in <= 8'b10010100;
	b_in <= 8'b01110111;	
	#10
	
	a_in <= 0;
	b_in <= 0;	
	
	#50
	en <= 1'b1;
	#50
	en <= 1'b0;
    end
    
endmodule