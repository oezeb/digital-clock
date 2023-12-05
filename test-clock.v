module TestClock();
    reg clk, set, reset;

    reg [5:0] sec_in;
    reg [5:0] min_in;
    reg [4:0] hour_in;

    wire [5:0] sec_out;
    wire [5:0] min_out;
    wire [4:0] hour_out;

    initial begin
        clk <= 0; set <= 0; reset <= 1;
        sec_in <= 62; min_in <= 58; hour_in <= 1;
        #1 reset <= 0;
        #100 set <= 1;
        #1 set <= 0;
        #400 $finish;
    end

    always #1 clk = ~clk;

    Clock Clock(
        .clk(clk), 
        .set(set),
        .reset(reset),
        .sec_in(sec_in),
        .min_in(min_in),
        .hour_in(hour_in),
        .sec_out(sec_out),
        .min_out(min_out),
        .hour_out(hour_out)
    );
endmodule