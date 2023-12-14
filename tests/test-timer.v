`include "../constants.vh"

module TestTimer();
    reg clk, reset, enable, increment;
    reg [1:0] select;

    wire [5:0] sec_out;
    wire [5:0] min_out;
    wire [4:0] hour_out;
    wire out;

    initial begin
        clk <= 0; reset <= 1; enable <= 0; increment <= 0; select <= `SELECT_NONE;
        #1 reset <= 0;
        #2 increment <= 1; #2 increment <= 0;
        #2 select <= `SELECT_SEC;
        #2 increment <= 1; #2 increment <= 0;
        #2 enable <= 1;
        #2 increment <= 1; #2 increment <= 0;
        #5 enable <= 0;
        #2 select <= `SELECT_MIN;
        #2 increment <= 1; #2 increment <= 0;
        #2 select <= `SELECT_HOUR;
        #2 increment <= 1; #2 increment <= 0;
        #2 enable <= 1;
        #50 $finish;
    end

    always #1 clk = ~clk;

    Timer #(2) Timer(
        .clk(clk),
        .reset(reset),
        .enable(enable),

        .select(select),
        .increment(increment),

        .sec_out(sec_out),
        .min_out(min_out),
        .hour_out(hour_out),

        .out(out)
    );
endmodule
