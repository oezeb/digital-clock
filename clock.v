`include "constants.v"

module Clock(
    input clk, reset,

    input [1:0] select,
    input increment,

    output reg [5:0] sec_out,
    output reg [5:0] min_out,
    output reg [4:0] hour_out
);
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            sec_out <= 0;
            min_out <= 0;
            hour_out <= 0;
        end
        else begin
            if(sec_out + 1 >= 60) begin
                sec_out <= 0;
                if(min_out + 1 >= 60) begin
                    min_out <= 0;
                    hour_out <= hour_out + 1 >= 24 ? 0 : hour_out + 1;
                end
                else begin
                    min_out <= min_out + 1;
                end
            end
            else begin
                sec_out <= sec_out + 1;
            end
        end
    end

    always @(posedge increment) begin
        case(select)
            `SELECT_SEC: sec_out <= 0;
            `SELECT_MIN: min_out <= min_out + 1 >= 60 ? 0 : min_out + 1;
            `SELECT_HOUR: hour_out <= hour_out + 1 >= 24 ? 0 : hour_out + 1;
        endcase
    end
endmodule
