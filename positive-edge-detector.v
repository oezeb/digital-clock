module PositiveEdgeDetector(
    input clk,
    input signal,
    output reg out
);
    reg prev_signal;

    always @(posedge clk) begin
        out <= signal & ~prev_signal;
        prev_signal <= signal;
    end
endmodule