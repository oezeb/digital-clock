`include "constants.v"

module TestDigitalClock();
    reg clk, global_reset, reset;

    reg [1:0] mode;

    reg [1:0] select;
    reg increment;

    reg alarm_enable;

    wire [6:0] ms_out;
    wire [5:0] sec_out;
    wire [5:0] min_out;
    wire [4:0] hour_out;

    wire alarm_out;

    initial begin
        clk <= 0; global_reset <= 1; reset <= 0;
        mode <= `MODE_CLOCK;
        select <= `SELECT_NONE;
        increment <= 0; alarm_enable <= 0;
        #1 global_reset <= 0;
        #5 reset <= 1; #1 reset <= 0;
        #1 increment <= 1;

        #5 mode <= `MODE_STOPWATCH;
        #5 mode <= `MODE_ALARM_EDIT;
        #5 increment <= 0;
        #5 mode <= `MODE_STOPWATCH;

        #5 mode <= `MODE_ALARM_EDIT; select <= `SELECT_SEC; 
        #1 global_reset <= 1; #1 global_reset <= 0; 
        #1 alarm_enable <= 1;
        #1 increment <= 1; #1 increment <= 0;
        #1 alarm_enable <= 0;

        #5 mode <= `MODE_CLOCK_EDIT; select <= `SELECT_SEC;
        #1 select <= `SELECT_MIN;
        #10 mode <= `MODE_CLOCK;

        #5 mode <= `MODE_CLOCK_EDIT; select <= `SELECT_HOUR;
        #1 increment <= 1; #1 increment <= 0;
        #4 increment <= 1; #1 increment <= 0;
        #5 $finish;
    end

    always #2 clk = ~clk;

    DigitalClock DigitalClock(
        .clk(clk),
        .global_reset(global_reset),
        .reset(reset),
        .mode(mode),
        .select(select),
        .increment(increment),
        .alarm_enable(alarm_enable),
        .ms_out(ms_out),
        .sec_out(sec_out),
        .min_out(min_out),
        .hour_out(hour_out),
        .alarm_out(alarm_out)
    );
endmodule