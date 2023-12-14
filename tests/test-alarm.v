`include "../constants.vh"

module TestAlarm();
    reg clk, reset, enable;

    wire [5:0] sec_in;
    wire [5:0] min_in;
    wire [4:0] hour_in;

    reg [1:0] select;
    reg increment;

    wire [5:0] sec_out;
    wire [5:0] min_out;
    wire [4:0] hour_out;

    wire out;
    
    reg clock_reset;

    initial begin
        clk <=0; reset <= 1; enable <= 0;
        clock_reset <= 1;
        select <= `SELECT_NONE; increment <= 0;
        #1 reset <= 0;
        #2 increment <= 1; #2 increment <= 0;
        #1 select <= `SELECT_SEC;
        #2 increment <= 1; #2 increment <= 0;
        #2 increment <= 1; #2 increment <= 0;
        #1 clock_reset <= 0; enable <= 1;
        #15 enable <= 0;
        #1 select <= `SELECT_MIN;
        #2 increment <= 1; #2 increment <= 0;
        #1 select <= `SELECT_HOUR;
        #2 increment <= 1; #2 increment <= 0;
        #5 $finish;
    end

    always #1 clk = ~clk;

    Clock #(2) Clock(
        .clk(clk), 
        .reset(clock_reset),
        .sec_out(sec_in),
        .min_out(min_in),
        .hour_out(hour_in)
    );

    Alarm Alarm(
        .clk(clk),
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