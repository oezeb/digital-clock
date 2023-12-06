module TestPosedgeDetector();
    reg clk, signal;
    wire out;

    initial begin
        clk <= 0; signal <= 0;
        #5 signal <= 1;
        #5 signal <= 0;
        #5 signal <= 1;
        #5 $finish;
    end

    always #1 clk <= ~clk;

    PosedgeDetector PosedgeDetector(
        .clk(clk),
        .signal(signal),
        .out(out)
    );
endmodule
