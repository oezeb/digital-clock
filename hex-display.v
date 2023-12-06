`include "constants.v"

module HexDisplay#(parameter CLK_FREQ_HZ = `KILO)( // CLK_FREQ_HZ >= 1KHz
    input clk, reset,
    input [31:0] all_data,
    output reg [3:0] data,
    output reg [2:0] an
);
    wire clk1KHz;

    always @(posedge clk1KHz or posedge reset) begin
        if(reset) begin
            an <= 0;
        end
        else begin
            an <= an + 1;
        end
    end

    always @* begin
        case (an)
            3'b000: begin
                data <= all_data[3:0];
            end
            3'b001: begin
                data <= all_data[7:4];
            end
            3'b010: begin
                data <= all_data[11:8];
            end
            3'b011: begin
                data <= all_data[15:12];
            end
            3'b100: begin
                data <= all_data[19:16];
            end
            3'b101: begin
                data <= all_data[23:20];
            end
            3'b110: begin
                data <= all_data[27:24];
            end
            3'b111: begin
                data <= all_data[31:28];
            end
            default: begin
                data <= 0;
            end
        endcase
    end

    ClockConverter #(CLK_FREQ_HZ, 1000) ClockConverter(
        .clk(clk),
        .clk_out(clk1KHz)
    );
endmodule
