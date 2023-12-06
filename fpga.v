`include "constants.v"

module FPGA(
    input clk, btn, 
    input [7:0] sw,
    output [3:0] seg_out,
    output [2:0] an_out,
    output [7:0] led
);
    wire global_reset, mode, start, reset;

    reg [1:0] clock_mode;
    reg [1:0] clock_select;
    wire clock_increment;
    reg clock_alarm_enable;

    wire [9:0] clock_ms_out;
    wire [5:0] clock_sec_out;
    wire [5:0] clock_min_out;
    wire [4:0] clock_hour_out;

    wire clock_alarm_out;

    wire [31:0] hexa_display_data;

    wire [11:0] ms_out_bcd;
    wire [7:0] sec_out_bcd;
    wire [7:0] min_out_bcd;
    wire [7:0] hour_out_bcd;

    assign global_reset = btn;
    assign mode = sw[0];
    assign start = sw[1];
    assign reset = sw[2];


    assign clock_increment = start;
    assign led = {clock_sec_out, clock_mode};
    assign hexa_display_data = clock_mode == `MODE_STOPWATCH ? {min_out_bcd, sec_out_bcd, ms_out_bcd} : {hour_out_bcd, min_out_bcd, sec_out_bcd};

    always @(posedge global_reset or posedge mode or posedge start or posedge reset) begin
        if(global_reset) begin
            clock_mode <= `MODE_CLOCK;
            clock_select <= `SELECT_NONE;
        end
        else if(mode) begin
            clock_mode <= clock_mode + 1;
            case (clock_mode + 1)
                `MODE_ALARM_EDIT, `MODE_CLOCK_EDIT: begin
                    clock_select <= `SELECT_SEC;
                end
            endcase
        end
        else begin
            case (clock_mode)
                `MODE_CLOCK: begin
                    clock_select <= `SELECT_NONE;
                    clock_alarm_enable <= start & reset;
                end
                `MODE_ALARM_EDIT, `MODE_CLOCK_EDIT: begin
                    if(reset) begin
                        clock_select <= clock_select + 1;
                    end
                end
            endcase
        end
    end

    DigitalClock #(100 * `MEGA) DigitalClock(
        .clk(clk),
        .global_reset(global_reset),
        .reset(reset),
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
        .clk(clk),
        .reset(global_reset),
        .data(hexa_display_data),
        .seg_out(seg_out),
        .an_out(an_out)
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


// module FPGA(
//     input clk, btn, 
//     input [7:0] sw,
//     output [3:0] seg_out,
//     output [2:0] an_out,
//     output [7:0] led
// );
//     wire [1:0] clock_select;
//     wire clock_increment;

//     wire [5:0] clock_sec_out;
//     wire [5:0] clock_min_out;
//     wire [4:0] clock_hour_out;

//     wire [7:0] clock_sec_out_bcd;
//     wire [7:0] clock_min_out_bcd;
//     wire [7:0] clock_hour_out_bcd;

//     wire [31:0] data;

//     assign clock_increment = sw[0];
//     assign clock_select = sw[2:1];
//     assign led = {2'b0, clock_sec_out };

//     assign data = {8'b0, clock_hour_out_bcd, clock_min_out_bcd, clock_sec_out_bcd};

//     Clock #(100 * `MEGA) Clock(
//         .clk(clk),
//         .reset(btn),
//         .select(clock_select),
//         .increment(clock_increment),
//         .sec_out(clock_sec_out),
//         .min_out(clock_min_out),
//         .hour_out(clock_hour_out)
//     );

//     HexDisplay #(100 * `MEGA) HexDisplay(
//         .clk(clk),
//         .reset(btn),
//         .data(data),
//         .seg_out(seg_out),
//         .an_out(an_out)
//     );

//     Bin2BCD Bin2BCD_sec(
//         .bin(clock_sec_out),
//         .bcd(clock_sec_out_bcd)
//     );

//     Bin2BCD Bin2BCD_min(
//         .bin(clock_min_out),
//         .bcd(clock_min_out_bcd)
//     );

//     Bin2BCD Bin2BCD_hour(
//         .bin(clock_hour_out),
//         .bcd(clock_hour_out_bcd)
//     );
// endmodule