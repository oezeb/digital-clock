`include "constants.v"

module TestAlarm ();
    reg reset, enable;

    reg clk, clock_reset;
    wire [5:0] sec_in;
    wire [5:0] min_in;
    wire [4:0] hour_in;

    reg [1:0] select;
    reg increment;

    wire [5:0] sec_out;
    wire [5:0] min_out;
    wire [4:0] hour_out;

    wire out;

    initial begin
        clk <=0; reset <= 1; enable <= 0;
        clock_reset <= 1;
        select <= `SELECT_NONE; increment <= 0;
        #1 reset <= 0;
        #1 increment <= 1; #1 increment <= 0;
        #1 select <= `SELECT_SEC;
        #1 increment <= 1; #1 increment <= 0;
        #1 increment <= 1; #1 increment <= 0;
        #1 clock_reset <= 0;
        #10 enable <= 1;
        #1 clock_reset <= 1; #1 clock_reset <= 0;
        #10 select <= `SELECT_MIN;
        #1 increment <= 1; #1 increment <= 0;
        #1 increment <= 1; #1 increment <= 0;
        #1 select <= `SELECT_HOUR;
        #1 increment <= 1; #1 increment <= 0;
        #1 increment <= 1; #1 increment <= 0;
        #5 $finish;
    end

    always #1 clk = ~clk;

    Clock Clock(
        .clk(clk), 
        .set(0),
        .reset(clock_reset),
        .sec_out(sec_in),
        .min_out(min_in),
        .hour_out(hour_in)
    );

    Alarm Alarm(
        .reset(reset),
        .enable(enable),
        .sec_in(sec_in),
        .min_in(min_in),
        .hour_in(hour_in),
        .select(select),
        .increment(increment),
        .sec_out(sec_out),
        .min_out(min_out),
        .hour_out(hour_out),
        .out(out)
    );
endmodule