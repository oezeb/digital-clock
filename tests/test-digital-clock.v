`include "../constants.vh"

module TestDigitalClock();
    reg clk, reset;

    reg [1:0] mode;

    reg [1:0] select;
    reg increment;

    reg alarm_enable, timer_enable;

    wire [5:0] sec_out;
    wire [5:0] min_out;
    wire [4:0] hour_out;

    wire alarm_out, timer_out;

    initial begin
        clk <= 0; reset <= 1;
        mode <= `MODE_CLOCK;
        select <= `SELECT_NONE; increment <= 0;
        alarm_enable <= 0; timer_enable <= 0;
        #1 reset <= 0;
        #2 mode <= `MODE_ALARM; select <= `SELECT_SEC;
        #2 increment <= 1; #2 increment <= 0;
        #2 increment <= 1; #2 increment <= 0;
        #2 mode <= `MODE_CLOCK; alarm_enable <= 1;
        #10 mode <= `MODE_TIMER; select <= `SELECT_SEC;
        #2 increment <= 1; #2 increment <= 0;
        #2 increment <= 1; #2 increment <= 0;
        #2 increment <= 1; #2 increment <= 0;
        #2 timer_enable <= 1;
        #25 mode <= `MODE_CLOCK; select <= `SELECT_SEC;
        #10 increment <= 1; #2 increment <= 0;
        #2 select <= `SELECT_MIN;
        #2 increment <= 1; #2 increment <= 0;
        #2 select <= `SELECT_HOUR;
        #2 increment <= 1; #2 increment <= 0;
        #2 alarm_enable <= 0; timer_enable <= 0;
        #10 $finish;
    end

    always #1 clk = ~clk;

    DigitalClock #(2) DigitalClock(
        .clk(clk), .reset(reset),
        .mode(mode),
        .select(select), .increment(increment),
        .alarm_enable(alarm_enable), .timer_enable(timer_enable),
        .sec_out(sec_out), .min_out(min_out), .hour_out(hour_out),
        .alarm_out(alarm_out), .timer_out(timer_out)
    );
endmodule