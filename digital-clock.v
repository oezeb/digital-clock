`include "constants.v"

module DigitalClock#(parameter CLK_FREQ_HZ = `KILO)( // CLK_FREQ_HZ >= 1KHz
    input clk, reset,
    
    input [1:0] mode, 

    input [1:0] select,
    input increment,

    input alarm_enable, timer_enable,

    output reg [5:0] sec_out,
    output reg [5:0] min_out,
    output reg [4:0] hour_out,

    output alarm_out, timer_out
);
    // clock
    wire [1:0] clock_select;

    wire [5:0] clock_sec_out;
    wire [5:0] clock_min_out;
    wire [4:0] clock_hour_out;

    // alarm
    wire [5:0] alarm_sec_in;
    wire [5:0] alarm_min_in;
    wire [4:0] alarm_hour_in;

    wire [1:0] alarm_select;

    wire [5:0] alarm_sec_out;
    wire [5:0] alarm_min_out;
    wire [4:0] alarm_hour_out;

    // timer
    wire [1:0] timer_select;

    wire [5:0] timer_sec_out;
    wire [5:0] timer_min_out;
    wire [4:0] timer_hour_out;


    // assign
    assign clock_select = mode == `MODE_CLOCK & ~reset ? select : `SELECT_NONE;
    assign alarm_select = mode == `MODE_ALARM & ~reset ? select : `SELECT_NONE;
    assign timer_select = mode == `MODE_TIMER & ~reset ? select : `SELECT_NONE;

    assign alarm_sec_in = clock_sec_out;
    assign alarm_min_in = clock_min_out;
    assign alarm_hour_in = clock_hour_out;
    
    always @* begin
        case (mode)
            `MODE_CLOCK: begin
                sec_out <= clock_sec_out;
                min_out <= clock_min_out;
                hour_out <= clock_hour_out;
            end
            `MODE_TIMER: begin
                sec_out <= timer_sec_out;
                min_out <= timer_min_out;
                hour_out <= timer_hour_out;
            end
            `MODE_ALARM: begin
                sec_out <= alarm_sec_out;
                min_out <= alarm_min_out;
                hour_out <= alarm_hour_out;
            end
            default: begin
                sec_out <= 0;
                min_out <= 0;
                hour_out <= 0;
            end
        endcase
    end

    Clock #(CLK_FREQ_HZ) Clock(
        .clk(clk),
        .reset(reset),
        .select(clock_select),
        .increment(increment),
        .sec_out(clock_sec_out),
        .min_out(clock_min_out),
        .hour_out(clock_hour_out)
    );

    Alarm Alarm(
        .clk(clk),
        .reset(reset),
        .enable(alarm_enable),
        .sec_in(alarm_sec_in),
        .min_in(alarm_min_in),
        .hour_in(alarm_hour_in),
        .select(alarm_select),
        .increment(increment),
        .sec_out(alarm_sec_out),
        .min_out(alarm_min_out),
        .hour_out(alarm_hour_out),
        .out(alarm_out)
    );

    Timer #(CLK_FREQ_HZ) Timer(
        .clk(clk),
        .reset(reset),
        .enable(timer_enable),
        .select(timer_select),
        .increment(increment),
        .sec_out(timer_sec_out),
        .min_out(timer_min_out),
        .hour_out(timer_hour_out),
        .out(timer_out)
    );
endmodule
