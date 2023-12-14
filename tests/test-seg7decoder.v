module TestSeg7Decoder();
    reg [3:0] in;
    wire [6:0] out;

    initial begin
        in <= 0;
        #1 in <= 1;
        #1 in <= 2;
        #1 in <= 3;
        #1 in <= 4;
        #1 in <= 5;
        #1 in <= 6;
        #1 in <= 7;
        #1 in <= 8;
        #1 in <= 9;
        #1 in <= 10;
        #1 $finish;
    end

    Seg7Decoder Seg7Decoder(
        .in(in),
        .CA(out[6]), 
        .CB(out[5]), 
        .CC(out[4]), 
        .CD(out[3]), 
        .CE(out[2]), 
        .CF(out[1]), 
        .CG(out[0])
    );
endmodule