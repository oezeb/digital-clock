module ClockConverter#(parameter FROM_HZ = 10, TO_HZ = 1)( // FROM_HZ > TO_HZ
    input clk,
    output reg clk_out
);
    reg [31:0] counter;
    reg [31:0] threshold;

    always @(posedge clk) begin
        counter <= counter + 1;
        if(counter >= threshold) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end
    end

    initial begin
        counter <= 0;
        threshold <= FROM_HZ / TO_HZ;
        clk_out <= 0;
    end
endmodule