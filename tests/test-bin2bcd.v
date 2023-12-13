module TestBin2BCD();
    reg [7:0] bin;
    wire [15:0] bcd;

    integer i;

    initial begin
        bin = 0;
        for(i = 0; i < 10; i = i + 1) begin
            #1 bin = bin + 1;
        end
        #10 $finish;
    end

    Bin2BCD Bin2BCD(
        .bin(bin),
        .bcd(bcd)
    );
endmodule