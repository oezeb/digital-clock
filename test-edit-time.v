module TestEditTime();
    reg clk, set, reset;

    reg [5:0] sec_in;
    reg [5:0] min_in;
    reg [4:0] hour_in;

    reg [1:0] select;
    reg increment;

    wire [5:0] sec_out;
    wire [5:0] min_out;
    wire [4:0] hour_out;

    initial begin
        clk <= 0; set <= 0; reset <= 1;
        sec_in <= 59; min_in <= 59; hour_in <= 23;
        select <= 0; increment <= 0;
        #1 reset <= 0;
        #1 set <= 1; #1 set <= 0;
        #10 increment <= 1; #1 increment <= 0;
        #1 select <= 1;
        #1 increment <= 1; #1 increment <= 0;
        #4 increment <= 1; #1 increment <= 0;
        #5 select <= 2;
        #1 increment <= 1; #1 increment <= 0;
        #4 increment <= 1; #1 increment <= 0;
        #1 select <= 3;
        #1 increment <= 1; #1 increment <= 0;
        #4 increment <= 1; #1 increment <= 0;
        #5 $finish;
    end

    always #1 clk = ~clk;

    EditTime EditTime(
        .clk(clk),
        .set(set), 
        .reset(reset),
        .sec_in(sec_in),
        .min_in(min_in),
        .hour_in(hour_in),
        .select(select),
        .increment(increment),
        .sec_out(sec_out),
        .min_out(min_out),
        .hour_out(hour_out)
    );
endmodule