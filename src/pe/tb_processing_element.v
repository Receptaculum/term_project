`timescale 1ns / 1ps

module tb_processing_element;
    wire [7:0] a_out, b_out, c_out;
    reg [7:0] a_in, b_in, c_in;
    reg clk, rst, mode;

    processing_element pe (.clk(clk), .rst(rst), .mode(mode), .a_in(a_in), .b_in(b_in), .c_in(c_in), .a_out(a_out), .b_out(b_out), .c_out(c_out));

	initial forever begin
    	#5 clk = ~clk;
	end

    initial begin	
        c_in <= 8'd4;
        mode <= 1'b0;
        a_in <= 8'b00000000;
        b_in <= 8'b00000000;
        clk <= 0;
        rst <= 1;
        
        #20
        rst <= 0;
        
        #10 // One Clk        
        a_in <= 8'b01110101;
        b_in <= 8'b00110111;
        
        #10 // One Clk
        a_in <= 8'b00010010;
        b_in <= 8'b00101100;
        
        #10 // One Clk
        a_in <= 8'b10010101;
        b_in <= 8'b01110101;	
     
        #10 // Operation End      
        a_in <= 0;
        b_in <= 0;	
        
        #50 // Mode = 1
        mode <= 1'b1;
        
        #50 // Mode = 0
        mode <= 1'b0;
    end
endmodule