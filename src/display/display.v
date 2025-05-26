`timescale 1ns / 1ps
module display(
    input clk,
    input resetn,
    input [7:0] c9_11, c9_12, c9_21, c9_22, 
                c4_11, c4_12, c4_21, c4_22,
    output reg [2:0] digit,
    output reg [7:0] seg_data
    );
    
    //clk
    wire clk_1hz;
    wire clk_1000hz;
    clock_divider #(49999) div1 (clk, clk_1000hz);
    clock_divider #(49999999) div2 (clk, clk_1hz);
    
    //fsm set
    parameter INI = 4'b0000;
    parameter S01 = 4'b0001;
    parameter S02 = 4'b0010;
    parameter S03 = 4'b0011;
    parameter S04 = 4'b0100;
    parameter S05 = 4'b0101;
    parameter S06 = 4'b0110;
    parameter S07 = 4'b0111;
    parameter S08 = 4'b1000;
    
    reg [3:0] state;
    reg [3:0] next_state;
    
    always @(posedge clk_1hz or negedge resetn) begin
        if (~resetn) state <= INI;
        else state <= next_state;
    end
    
    always @(posedge clk_1000hz) begin
        if (~resetn) next_state = INI;
        else
            case (state)
                INI : next_state = S01;
                S01 : next_state = S02;
                S02 : next_state = S03;
                S03 : next_state = S04;
                S04 : next_state = S05;
                S05 : next_state = S06;
                S06 : next_state = S07;
                S07 : next_state = S08;
                S08 : next_state = S08;
            endcase
    end
    
    //BCD
    wire [11:0] c9_11_d, c9_12_d, c9_21_d, c9_22_d;
    wire [11:0] c4_11_d, c4_12_d, c4_21_d, c4_22_d;
    
    Bi_to_BCD_gate_level converter1 (c9_11, c9_11_d[11:8], c9_11_d[7:4], c9_11_d[3:0]);
    Bi_to_BCD_gate_level converter2 (c9_12, c9_12_d[11:8], c9_12_d[7:4], c9_12_d[3:0]);
    Bi_to_BCD_gate_level converter3 (c9_21, c9_21_d[11:8], c9_21_d[7:4], c9_21_d[3:0]);
    Bi_to_BCD_gate_level converter4 (c9_22, c9_22_d[11:8], c9_22_d[7:4], c9_22_d[3:0]);
    Bi_to_BCD_gate_level converter5 (c4_11, c4_11_d[11:8], c4_11_d[7:4], c4_11_d[3:0]);
    Bi_to_BCD_gate_level converter6 (c4_12, c4_12_d[11:8], c4_12_d[7:4], c4_12_d[3:0]);
    Bi_to_BCD_gate_level converter7 (c4_21, c4_21_d[11:8], c4_21_d[7:4], c4_21_d[3:0]);
    Bi_to_BCD_gate_level converter8 (c4_22, c4_22_d[11:8], c4_22_d[7:4], c4_22_d[3:0]);
    
    //decoder
    reg [3:0] decoder_f_in, decoder_s_in, decoder_t_in;
    wire [23:0] seg_data_group;
    
    decoder_gate_level decoder_f (decoder_f_in, seg_data_group[23:16]);
    decoder_gate_level decoder_s (decoder_s_in, seg_data_group[15:8]);
    decoder_gate_level decoder_t (decoder_t_in, seg_data_group[7:0]);
    
    //seg_data rotation
    reg [1:0] i;
    
    //fsm state
    always @(state or i) begin
        case (state)
            INI : begin
                decoder_f_in <= 4'b0000;
                decoder_s_in <= 4'b0000;
                decoder_t_in <= 4'b0000;
            end
            
            S01 : begin 
                decoder_f_in <= c9_11_d[11:8];
                decoder_s_in <= c9_11_d[7:4];
                decoder_t_in <= c9_11_d[3:0];
            end
            
            S02 : begin
                decoder_f_in <= c9_12_d[11:8];
                decoder_s_in <= c9_12_d[7:4];
                decoder_t_in <= c9_12_d[3:0];
            end
            
            S03 : begin
                decoder_f_in <= c9_21_d[11:8];
                decoder_s_in <= c9_21_d[7:4];
                decoder_t_in <= c9_21_d[3:0];
            end
            
            S04 : begin
                decoder_f_in <= c9_22_d[11:8];
                decoder_s_in <= c9_22_d[7:4];
                decoder_t_in <= c9_22_d[3:0];
            end
            
            S05 : begin
                decoder_f_in <= c4_11_d[11:8];
                decoder_s_in <= c4_11_d[7:4];
                decoder_t_in <= c4_11_d[3:0];
            end
            
            S06 : begin
                decoder_f_in <= c4_12_d[11:8];
                decoder_s_in <= c4_12_d[7:4];
                decoder_t_in <= c4_12_d[3:0];
            end
            
            S07 : begin
                decoder_f_in <= c4_21_d[11:8];
                decoder_s_in <= c4_21_d[7:4];
                decoder_t_in <= c4_21_d[3:0];
            end
            
            S08 : begin
                decoder_f_in <= c4_22_d[11:8];
                decoder_s_in <= c4_22_d[7:4];
                decoder_t_in <= c4_22_d[3:0];
            end
        endcase
        
        //digit rotation
        case (i)
            2'b00 : begin
                digit <= 3'b000; seg_data <= 8'b0000_0000;
            end
            2'b01 : begin
                digit <= 3'b100; seg_data <= seg_data_group[23:16];
            end
            2'b10 : begin
                digit <= 3'b010; seg_data <= seg_data_group[15:8];
            end
            2'b11 : begin
                digit <= 3'b001; seg_data <= seg_data_group[7:0];
            end
        endcase
    end
        
    always @(posedge clk_1000hz or negedge resetn) begin
        if (~resetn) i = 0;
        else begin
            if (i < 3) begin
                i <= i + 1;
            end
            else i <= 1;
        end
    end

endmodule