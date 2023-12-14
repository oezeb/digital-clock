module TestBin2BCD();
    reg [7:0] bin;
    wire [9:0] bcd;


    initial begin
        bin = 0;
        #1 bin = 3;
        #1 bin = 10;
        #1 bin = 13;
        #1 bin = 20;
        #1 bin = 24;
        #1 bin = 30;
        #1 bin = 36;
        #1 bin = 40;
        #1 bin = 49;
        #1 $finish;
    end

    Bin2BCD Bin2BCD(
        .bin(bin),
        .bcd(bcd)
    );
endmodule