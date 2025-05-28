`timescale 1ns / 1ps

module controller (
    input clk,
    input rst,
    output reg rst_mem,
    output reg rst_pe,
    output reg rst_3b3,
    output reg rst_2b2,
    output reg rst_disp
);

    // 상태 정의
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010,
              S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

    reg [2:0] state;
    reg [31:0] counter;

    // 사용자 정의 시간 (100MHz 기준, 1초 = 100,000,000)
    parameter TIME_S0 = 200,
              TIME_S1 = 200,   
              TIME_S2 = 4000,  
              TIME_S3 = 2000,   
              TIME_S4 = 2000;

    // 상태 전이 및 카운터
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= S0;
            counter <= 0;
            rst_mem <= 1; rst_pe <= 1; rst_3b3 <= 1; rst_2b2 <= 1; rst_disp <= 0;
		end	

        else begin
            case (state)
                S0: begin
                    rst_mem <= 1; rst_pe <= 1; rst_3b3 <= 1; rst_2b2 <= 1; rst_disp <= 0;    
                    if (counter >= TIME_S0) begin
                        state <= S1;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                S1: begin
                    rst_mem <= 0; rst_pe <= 1; rst_3b3 <= 1; rst_2b2 <= 1; rst_disp <= 0;
                    if (counter >= TIME_S1) begin
                        state <= S2;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                S2: begin
                    rst_mem <= 0; rst_pe <= 0; rst_3b3 <= 1; rst_2b2 <= 1; rst_disp <= 0;
                    if (counter >= TIME_S2) begin
                        state <= S3;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                S3: begin
                    rst_mem <= 0; rst_pe <= 0; rst_3b3 <= 0; rst_2b2 <= 1; rst_disp <= 0;
                    if (counter >= TIME_S3) begin
                        state <= S4;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                S4: begin
                    rst_mem <= 0; rst_pe <= 0; rst_3b3 <= 0; rst_2b2 <= 0; rst_disp <= 0;
                    if (counter >= TIME_S4) begin
                        state <= S5;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                S5: begin
                    rst_mem <= 0; rst_pe <= 0; rst_3b3 <= 0; rst_2b2 <= 0; rst_disp <= 1;
                end
            endcase
        end
    end
endmodule