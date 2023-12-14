`include "constants.vh"

module Alarm (
    input clk,
    input reset, enable,
    
    input [5:0] sec_in,
    input [5:0] min_in,
    input [4:0] hour_in,
    
    input [1:0] select,
    input increment,

    output reg [5:0] sec_out,
    output reg [5:0] min_out,
    output reg [4:0] hour_out,

    output reg out
);
    reg prev_increment;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            sec_out <= 0;
            min_out <= 0;
            hour_out <= 0;
            out <= 0;
        end
        else begin
            if(increment & ~prev_increment) begin
                case(select)
                    `SELECT_SEC: sec_out <= sec_out + 1 > 59 ? 0 : sec_out + 1;
                    `SELECT_MIN: min_out <= min_out + 1 > 59 ? 0 : min_out + 1;
                    `SELECT_HOUR: hour_out <= hour_out + 1 > 23 ? 0 : hour_out + 1;
                endcase
            end

            if(enable) begin
                if(~out) begin
                    out <= hour_out == hour_in & min_out == min_in & sec_out == sec_in;
                end
            end
            else begin
                out <= 0;
            end
        end

        prev_increment <= increment;
    end
endmodule
