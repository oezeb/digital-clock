module TestClock();
    reg clk, reset;

    reg [1:0] select;
    reg increment;

    wire [5:0] sec_out;
    wire [5:0] min_out;
    wire [4:0] hour_out;

    integer i;

    initial begin
        clk <= 0; reset <= 1;
        select <= 0; increment <= 0;
        #1 reset <= 0;
        #2 increment <= 1; #2 increment <= 0;
        #3 increment <= 1; #2 increment <= 0;
        #2 select <= 1;
        #2 increment <= 1; #2 increment <= 0;
        #3 increment <= 1; #2 increment <= 0;
        #2 select <= 2;
        for (i = 0; i < 58; i = i + 1) begin
            #2 increment <= 1; #2 increment <= 0;
        end
        #2 select <= 3;
        for (i = 0; i < 23; i = i + 1) begin
            #2 increment <= 1; #2 increment <= 0;
        end
        #100 $finish;
    end

    always #1 clk = ~clk;

    Clock #(2) Clock(
        .clk(clk), 
        .reset(reset),
        .select(select),
        .increment(increment),
        .sec_out(sec_out),
        .min_out(min_out),
        .hour_out(hour_out)
    );
endmodule