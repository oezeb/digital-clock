`include "../constants.v"

module FPGAOL(
    input CLK100MHZ, btn, 
    input [7:0] sw,
    output [3:0] hexplay_data,
    output [2:0] hexplay_an,
    output [7:0] led
);
    // digital clock
    wire reset;
    wire [1:0] mode;
    wire [1:0] select;
    wire increment;
    wire alarm_enable;
    wire timer_enable;

    wire [5:0] sec_out;
    wire [5:0] min_out;
    wire [4:0] hour_out;
    wire alarm_out, timer_out;

    // hex display
    wire [31:0] hexdisplay_all_data;

    // bin to bcd
    wire [7:0] sec_out_bcd;
    wire [7:0] min_out_bcd;
    wire [7:0] hour_out_bcd;

    // assign
    assign reset = sw[7];
    assign alarm_enable = sw[6];
    assign timer_enable = sw[5];
    assign increment = btn;
    assign select = sw[3:2];
    assign mode = sw[1:0];

    assign led = {reset, alarm_out, timer_out, increment, select, mode};
    assign hexdisplay_all_data = {hour_out_bcd, min_out_bcd, sec_out_bcd};

    DigitalClock #(100 * `MEGA) DigitalClock(
        .clk(CLK100MHZ),
        .reset(reset),
        .mode(mode),
        .select(select),
        .increment(increment),
        .alarm_enable(alarm_enable),
        .timer_enable(timer_enable),
        .sec_out(sec_out),
        .min_out(min_out),
        .hour_out(hour_out),
        .alarm_out(alarm_out),
        .timer_out(timer_out)
    );

    HexDisplay #(100 * `MEGA) HexDisplay(
        .clk(CLK100MHZ),
        .reset(reset),
        .all_data(hexdisplay_all_data),
        .data(hexplay_data),
        .an(hexplay_an)
    );

    Bin2BCD #(8) Bin2BCD_sec(
        .bin(sec_out),
        .bcd(sec_out_bcd)
    );

    Bin2BCD #(8) Bin2BCD_min(
        .bin(min_out),
        .bcd(min_out_bcd)
    );

    Bin2BCD #(8) Bin2BCD_hour(
        .bin(hour_out),
        .bcd(hour_out_bcd)
    );
endmodule
