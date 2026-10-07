`timescale 1ns/1ps

module Dice4_tb;

    reg clk;
    reg reset;
    reg player_btn;

    wire [6:0] seg;
    wire [3:0] player_leds;
    wire extra_led;

    Dice4 DUT (
        .clk(clk),
        .reset(reset),
        .player_btn(player_btn),
        .seg(seg),
        .player_leds(player_leds),
        .extra_led(extra_led)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        player_btn = 0;

        #20;
        reset = 0;

        #50 player_btn = 1;
        #20 player_btn = 0;

        #100 player_btn = 1;
        #20 player_btn = 0;

        #200 player_btn = 1;
        #20 player_btn = 0;

        #500;
        $stop;
    end

endmodule
