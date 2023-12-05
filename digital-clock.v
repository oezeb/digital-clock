`include "constants.v"

module DigitalClock(
    input clk, global_reset, reset,

    input [1:0] mode,

    input [1:0] select,
    input increment,

    input alarm_enable,

    output reg [6:0] ms_out,
    output reg [5:0] sec_out,
    output reg [5:0] min_out,
    output reg [4:0] hour_out,

    output alarm_out
);
    // clock
    wire clock_reset;

    wire [1:0] clock_select;
    wire clock_increment;

    wire [5:0] clock_sec_out;
    wire [5:0] clock_min_out;
    wire [4:0] clock_hour_out;

    // stop watch
    wire stopwatch_reset;
    wire stopwatch_enable;

    wire [6:0] stopwatch_ms_out;
    wire [5:0] stopwatch_sec_out;
    wire [5:0] stopwatch_min_out;

    // alarm
    wire alarm_reset;
    wire [5:0] alarm_sec_in;
    wire [5:0] alarm_min_in;
    wire [4:0] alarm_hour_in;

    wire [1:0] alarm_select;
    wire alarm_increment;

    wire [5:0] alarm_sec_out;
    wire [5:0] alarm_min_out;
    wire [4:0] alarm_hour_out;

    // assign
    assign clock_reset = global_reset;
    assign clock_increment = increment;
    assign clock_select = mode == `MODE_CLOCK_EDIT & ~global_reset ? select : `SELECT_NONE;

    assign stopwatch_reset = mode == `MODE_STOPWATCH & ~global_reset ? reset : global_reset;
    assign stopwatch_enable = mode == `MODE_STOPWATCH & ~global_reset ? increment : 0;

    assign alarm_reset = global_reset;
    assign alarm_increment = increment;
    assign alarm_select = mode == `MODE_ALARM_EDIT & ~global_reset ? select : `SELECT_NONE;
    assign alarm_sec_in = clock_sec_out;
    assign alarm_min_in = clock_min_out;
    assign alarm_hour_in = clock_hour_out;
    
    always @* begin
        case (mode)
            `MODE_CLOCK, `MODE_CLOCK_EDIT: begin
                // output
                ms_out <= 0;
                sec_out <= clock_sec_out;
                min_out <= clock_min_out;
                hour_out <= clock_hour_out;
            end
            `MODE_STOPWATCH: begin
                // output
                ms_out <= stopwatch_ms_out;
                sec_out <= stopwatch_sec_out;
                min_out <= stopwatch_min_out;
                hour_out <= 0;
            end
            `MODE_ALARM_EDIT: begin
                // output
                ms_out <= 0;
                sec_out <= alarm_sec_out;
                min_out <= alarm_min_out;
                hour_out <= alarm_hour_out;
            end
        endcase
    end

    Clock Clock(
        .clk(clk), 
        .reset(clock_reset),
        .select(clock_select),
        .increment(clock_increment),
        .sec_out(clock_sec_out),
        .min_out(clock_min_out),
        .hour_out(clock_hour_out)
    );
    
    Stopwatch Stopwatch(
        .clk(clk),
        .reset(stopwatch_reset),
        .enable(stopwatch_enable),
        .ms_out(stopwatch_ms_out),
        .sec_out(stopwatch_sec_out),
        .min_out(stopwatch_min_out)
    );

    Alarm Alarm(
        .reset(alarm_reset),
        .enable(alarm_enable),
        .sec_in(alarm_sec_in),
        .min_in(alarm_min_in),
        .hour_in(alarm_hour_in),
        .select(alarm_select),
        .increment(alarm_increment),
        .sec_out(alarm_sec_out),
        .min_out(alarm_min_out),
        .hour_out(alarm_hour_out),
        .out(alarm_out)
    );
endmodule