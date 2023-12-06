`include "constants.v"

module FPGA(
    input CLK100MHZ, btn, 
    input [7:0] sw,
    output [3:0] hexplay_data,
    output [2:0] hexplay_an,
    output [7:0] led
);
    // digital clock
    wire clock_global_reset;
    wire clock_reset;
    wire [1:0] clock_mode;
    wire [1:0] clock_select;
    wire clock_increment;
    wire clock_alarm_enable;

    wire [9:0] clock_ms_out;
    wire [5:0] clock_sec_out;
    wire [5:0] clock_min_out;
    wire [4:0] clock_hour_out;

    wire clock_alarm_out;

    // hex display
    wire [31:0] hexdisplay_all_data;

    // bin to bcd
    wire [11:0] ms_out_bcd;
    wire [7:0] sec_out_bcd;
    wire [7:0] min_out_bcd;
    wire [7:0] hour_out_bcd;

    // assign
    assign clock_global_reset = sw[7];
    assign clock_reset = sw[6];
    assign clock_alarm_enable = sw[5];
    assign clock_select = sw[3:2];
    assign clock_mode = sw[1:0];
    assign clock_increment = btn;

    assign led = {clock_global_reset, clock_reset, clock_alarm_out, clock_increment, clock_select, clock_mode};
    assign hexdisplay_all_data = clock_mode == `MODE_STOPWATCH ? {min_out_bcd, sec_out_bcd, ms_out_bcd} : {hour_out_bcd, min_out_bcd, sec_out_bcd};

    DigitalClock #(100 * `MEGA) DigitalClock(
        .clk(CLK100MHZ),
        .global_reset(clock_global_reset),
        .reset(clock_reset),
        .mode(clock_mode),
        .select(clock_select),
        .increment(clock_increment),
        .alarm_enable(clock_alarm_enable),
        .ms_out(clock_ms_out),
        .sec_out(clock_sec_out),
        .min_out(clock_min_out),
        .hour_out(clock_hour_out),
        .alarm_out(clock_alarm_out)
    );

    HexDisplay #(100 * `MEGA) HexDisplay(
        .clk(CLK100MHZ),
        .reset(clock_global_reset),
        .all_data(hexdisplay_all_data),
        .data(hexplay_data),
        .an(hexplay_an)
    );

    Bin2BCD #(12) Bin2BCD_ms(
        .bin(clock_ms_out),
        .bcd(ms_out_bcd)
    );

    Bin2BCD #(8) Bin2BCD_sec(
        .bin(clock_sec_out),
        .bcd(sec_out_bcd)
    );

    Bin2BCD #(8) Bin2BCD_min(
        .bin(clock_min_out),
        .bcd(min_out_bcd)
    );

    Bin2BCD #(8) Bin2BCD_hour(
        .bin(clock_hour_out),
        .bcd(hour_out_bcd)
    );
endmodule
