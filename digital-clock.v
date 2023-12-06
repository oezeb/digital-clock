`include "constants.v"

module DigitalClock#(parameter CLK_FREQ_HZ = `KILO)( // CLK_FREQ_HZ >= 1KHz
    input clk, global_reset, reset,
    
    input [1:0] mode, 

    input [1:0] select,
    input increment,

    input alarm_enable,

    output reg [9:0] ms_out,
    output reg [5:0] sec_out,
    output reg [5:0] min_out,
    output reg [4:0] hour_out,

    output alarm_out
);
    wire increment_posedge;

    // clock
    wire [1:0] clock_select;
    wire clock_increment;

    wire [5:0] clock_sec_out;
    wire [5:0] clock_min_out;
    wire [4:0] clock_hour_out;

    // stop watch
    wire stopwatch_reset;
    reg stopwatch_enable;
    wire stopwatch_start;
    wire stopwatch_stop;

    wire [9:0] stopwatch_ms_out;
    wire [5:0] stopwatch_sec_out;
    wire [5:0] stopwatch_min_out;

    // alarm
    wire [5:0] alarm_sec_in;
    wire [5:0] alarm_min_in;
    wire [4:0] alarm_hour_in;

    wire [1:0] alarm_select;
    wire alarm_increment;

    wire [5:0] alarm_sec_out;
    wire [5:0] alarm_min_out;
    wire [4:0] alarm_hour_out;

    // assign
    assign clock_increment = increment;
    assign clock_select = mode == `MODE_CLOCK_EDIT & ~global_reset ? select : `SELECT_NONE;

    assign alarm_increment = increment;
    assign alarm_select = mode == `MODE_ALARM_EDIT & ~global_reset ? select : `SELECT_NONE;

    assign alarm_sec_in = clock_sec_out;
    assign alarm_min_in = clock_min_out;
    assign alarm_hour_in = clock_hour_out;
    
    assign stopwatch_reset = mode == `MODE_STOPWATCH & ~global_reset ? reset : global_reset;
    assign stopwatch_start = stopwatch_enable;
    assign stopwatch_stop = ~stopwatch_enable;
    
    always @(posedge clk or posedge global_reset) begin
        if (global_reset) begin
            stopwatch_enable <= 0;
        end
        else if(mode == `MODE_STOPWATCH & increment_posedge) begin
            stopwatch_enable <= ~stopwatch_enable;
        end
    end
    
    always @* begin
        case (mode)
            `MODE_CLOCK, `MODE_CLOCK_EDIT: begin
                ms_out <= 0;
                sec_out <= clock_sec_out;
                min_out <= clock_min_out;
                hour_out <= clock_hour_out;
            end
            `MODE_STOPWATCH: begin
                ms_out <= stopwatch_ms_out;
                sec_out <= stopwatch_sec_out;
                min_out <= stopwatch_min_out;
                hour_out <= 0;
            end
            `MODE_ALARM_EDIT: begin
                ms_out <= 0;
                sec_out <= alarm_sec_out;
                min_out <= alarm_min_out;
                hour_out <= alarm_hour_out;
            end
        endcase
    end

    Clock #(CLK_FREQ_HZ) Clock(
        .clk(clk),
        .reset(global_reset),
        .select(clock_select),
        .increment(clock_increment),
        .sec_out(clock_sec_out),
        .min_out(clock_min_out),
        .hour_out(clock_hour_out)
    );
    
    Stopwatch #(CLK_FREQ_HZ) Stopwatch(
        .clk(clk),
        .reset(stopwatch_reset),
        .start(stopwatch_start),
        .stop(stopwatch_stop),
        .ms_out(stopwatch_ms_out),
        .sec_out(stopwatch_sec_out),
        .min_out(stopwatch_min_out)
    );

    Alarm Alarm(
        .clk(clk),
        .reset(global_reset),
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

    PosedgeDetector PosedgeDetector_increment(
        .clk(clk),
        .signal(increment),
        .out(increment_posedge)
    );
endmodule