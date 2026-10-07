module Dice4 (
    input wire clk,
    input wire reset,
    input wire player_btn,

    output reg [6:0] seg,
    output reg [3:0] player_leds,
    output reg extra_led
);

reg game_started = 0;
reg sync0, sync1, prev;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        sync0 <= 0;
        sync1 <= 0;
        prev <= 0;
    end else begin
        sync0 <= player_btn;
        sync1 <= sync0;
        prev <= sync1;
    end
end

wire btn_rising = sync1 & ~prev;

reg [2:0] lfsr = 3'b001;
wire feedback = lfsr[2] ^ lfsr[1];

always @(posedge clk or posedge reset) begin
    if (reset)
        lfsr <= 3'b001;
    else
        lfsr <= {lfsr[1:0], feedback};
end

function [2:0] dice_map;
    input [2:0] x;
    begin
        case (x)
            3'b001: dice_map = 3'd1;
            3'b010: dice_map = 3'd2;
            3'b011: dice_map = 3'd3;
            3'b100: dice_map = 3'd4;
            3'b101: dice_map = 3'd5;
            3'b110: dice_map = 3'd6;
            default: dice_map = 3'd1;
        endcase
    end
endfunction

reg [1:0] player_turn = 2'b00;
reg [2:0] dice_val = 3'd1;
reg rolling = 1'b0;
reg [2:0] roll_cnt = 3'd0;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        player_turn <= 2'b00;
        dice_val <= 3'd1;
        extra_led <= 1'b0;
        game_started <= 0;
        rolling <= 1'b0;
        roll_cnt <= 3'd0;
    end else begin
        if (btn_rising && !rolling) begin
            game_started <= 1;
            rolling <= 1'b1;
            roll_cnt <= 3'd0;
        end else if (rolling) begin
            dice_val <= dice_map(lfsr);
            if (roll_cnt == 3'd4) begin
                rolling <= 1'b0;
                roll_cnt <= 3'd0;

                if (dice_map(lfsr) == 6) begin
                    extra_led <= 1'b1;
                end else begin
                    extra_led <= 1'b0;
                    if (player_turn == 2'b11)
                        player_turn <= 2'b00;
                    else
                        player_turn <= player_turn + 1;
                end
            end else begin
                roll_cnt <= roll_cnt + 3'd1;
            end
        end
    end
end

always @(*) begin
    if (!game_started)
        player_leds = 4'b0001;
    else begin
        case (player_turn)
            2'b00: player_leds = 4'b0001;
            2'b01: player_leds = 4'b0011;
            2'b10: player_leds = 4'b0111;
            2'b11: player_leds = 4'b1111;
            default: player_leds = 4'b0000;
        endcase
    end
end

always @(*) begin
    if (reset)
        seg = 7'b0000000;
    else begin
        case (dice_val)
            3'd1: seg = 7'b1001111;
            3'd2: seg = 7'b0010010;
            3'd3: seg = 7'b0000110;
            3'd4: seg = 7'b1001100;
            3'd5: seg = 7'b0100100;
            3'd6: seg = 7'b0100000;
            default: seg = 7'b0000000;
        endcase
    end
end

endmodule
