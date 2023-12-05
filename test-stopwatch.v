module TestStopwatch();
    reg clk, reset, enable;

    wire [6:0] ms_out;
    wire [5:0] sec_out;
    wire [5:0] min_out;

    initial begin
        clk <= 0; reset <= 1; enable <= 1;
        #1 reset <= 0;
        #900 enable <= 0;
        #50 enable <= 1;
        #50 $finish;
    end

    always #1 clk = ~clk;

    Stopwatch Stopwatch(
        .clk(clk), 
        .reset(reset),
        .enable(enable),
        .ms_out(ms_out),
        .sec_out(sec_out),
        .min_out(min_out)
    );
endmodule