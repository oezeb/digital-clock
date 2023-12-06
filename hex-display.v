`include "constants.v"

module HexDisplay#(parameter CLK_FREQ_HZ = `KILO)( // CLK_FREQ_HZ >= 1KHz
    input clk, reset,
    input [31:0] data,
    output reg [3:0] seg_out,
    output reg [2:0] an_out
);
    wire clk1KHz;

    always @(posedge clk1KHz or posedge reset) begin
        if(reset) begin
            an_out <= 0;
        end
        else begin
            an_out <= an_out + 1;
        end
    end

    always @* begin
        case (an_out)
            3'b000: begin
                seg_out <= data[3:0];
            end
            3'b001: begin
                seg_out <= data[7:4];
            end
            3'b010: begin
                seg_out <= data[11:8];
            end
            3'b011: begin
                seg_out <= data[15:12];
            end
            3'b100: begin
                seg_out <= data[19:16];
            end
            3'b101: begin
                seg_out <= data[23:20];
            end
            3'b110: begin
                seg_out <= data[27:24];
            end
            3'b111: begin
                seg_out <= data[31:28];
            end
            default: begin
                seg_out <= 0;
            end
        endcase
    end

    ClockConverter #(CLK_FREQ_HZ, 1000) ClockConverter(
        .clk(clk),
        .clk_out(clk1KHz)
    );
endmodule
