`include "constants.v"

module Alarm (
    input reset, enable,
    
    input [5:0] sec_in,
    input [5:0] min_in,
    input [4:0] hour_in,
    
    input [1:0] select,
    input increment,

    output reg [5:0] sec_out,
    output reg [5:0] min_out,
    output reg [4:0] hour_out,

    output out
);

    assign out = enable & hour_out == hour_in & min_out == min_in & sec_out == sec_in;

    always @(posedge reset or posedge increment) begin
        if(reset) begin
            sec_out <= 0;
            min_out <= 0;
            hour_out <= 0;
        end
        else if(increment) begin
            case(select)
                `SELECT_SEC: sec_out <= sec_out + 1 >= 60 ? 0 : sec_out + 1;
                `SELECT_MIN: min_out <= min_out + 1 >= 60 ? 0 : min_out + 1;
                `SELECT_HOUR: hour_out <= hour_out + 1 >= 24 ? 0 : hour_out + 1;
            endcase
        end     
    end
endmodule