module controller (
    input clk,
    input rst,
    output reg rst_mem,
    output reg rst_pe,
    output reg rst_3b3,
    output reg rst_2b2,
    output reg rst_disp,
	
	//임시 추가
	output [2:0] state
);

    // 상태 정의
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010,
              S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

    reg [2:0] state, next_state;
    reg [31:0] counter;
    reg [31:0] target_count;

    // 사용자 정의 시간 (100MHz 기준, 1초 = 100,000,000)
    parameter TIME_S0 = 100,
              TIME_S1 = 100,   
              TIME_S2 = 100,  
              TIME_S3 = 100,   
              TIME_S4 = 100;   
              // S5는 종료 상태로 고정됨

    // 상태 전이 및 카운터
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= S0;
            counter <= 0;
			
        end else begin
            if (counter >= target_count) begin
                state <= next_state;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    // 다음 상태 및 시간 설정
    always @(posedge clk) begin
        next_state = state;
        target_count = TIME_S0;

        case (state)
            S0: begin
                next_state = S1;
                target_count = TIME_S0;
            end
            S1: begin
                next_state = S2;
                target_count = TIME_S1;
            end
            S2: begin
                next_state = S3;
                target_count = TIME_S2;
            end
            S3: begin
                next_state = S4;
                target_count = TIME_S3;
            end
            S4: begin
                next_state = S5;
                target_count = TIME_S4;
            end
            S5: begin
                next_state = S5;       // display 유지
                target_count = 0;      // 무한 유지
            end
    	endcase
    end

    // 출력 신호 제어 (Moore 방식)
	always @ (state) begin
        case (state)
                S0: begin rst_mem <= 1; rst_pe <= 1; rst_3b3 <= 1; rst_2b2 <= 1; rst_disp <= 1; end // 11111
                S1: begin rst_mem <= 0; rst_pe <= 1; rst_3b3 <= 1; rst_2b2 <= 1; rst_disp <= 1; end // 01111
                S2: begin rst_mem <= 0; rst_pe <= 0; rst_3b3 <= 1; rst_2b2 <= 1; rst_disp <= 1; end // 00111
                S3: begin rst_mem <= 0; rst_pe <= 0; rst_3b3 <= 0; rst_2b2 <= 1; rst_disp <= 1; end // 00011
                S4: begin rst_mem <= 0; rst_pe <= 0; rst_3b3 <= 0; rst_2b2 <= 0; rst_disp <= 1; end // 00001
                S5: begin rst_mem <= 0; rst_pe <= 0; rst_3b3 <= 0; rst_2b2 <= 0; rst_disp <= 0; end // 00000           
        endcase
    end
endmodule