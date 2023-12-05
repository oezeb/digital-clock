`include "constants.v"

module EditTime(
    input clk, set, reset,
    input [5:0] sec_in,
    input [5:0] min_in,
    input [4:0] hour_in,

    input [1:0] select,
    input increment,

    output reg [5:0] sec_out,
    output reg [5:0] min_out,
    output reg [4:0] hour_out
);
    always @(posedge clk or posedge reset or posedge set) begin
        if(reset) begin
            sec_out <= 0;
            min_out <= 0;
            hour_out <= 0;
        end
        else if(set) begin
            sec_out <= sec_in >= 60 ? 0 : sec_in;
            min_out <= min_in >= 60 ? 0 : min_in;
            hour_out <= hour_in >= 24 ? 0 : hour_in;
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
