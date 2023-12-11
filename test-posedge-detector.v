module TestPosedgeDetector();
    reg clk, signal;
    wire out;

    initial begin
        clk <= 0; signal <= 0;
        #200 signal <= 1;
        #200 signal <= 0;
        #201 signal <= 1;
        #201 $finish;
    end

    always #1 clk <= ~clk;

    PosedgeDetector PosedgeDetector(
        .clk(clk),
        .signal(signal),
        .out(out)
    );
endmodule
