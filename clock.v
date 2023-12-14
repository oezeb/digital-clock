`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Author: github.com/oezeb
// 
// Module Name: Clock
// Project Name: Digital Clock
// Creation Date: 2023-12-11
// Description: Implements a 24-hour clock. The `select` and `increment` inputs can be used
//             to edit the time(`sec_out`, `min_out`, `hour_out`). Because the clock is
//             running while editing, the `sec_out` will be reset to 0 when trying to edit
//             the seconds. 
//
//////////////////////////////////////////////////////////////////////////////////

module Clock#(parameter CLK_FREQ_HZ = `KILO)( // CLK_FREQ_HZ >= 1Hz
    input clk, reset,

    input [1:0] select, // values: `SELECT_NONE, `SELECT_SEC, `SELECT_MIN, `SELECT_HOUR
    input increment,

    output reg [5:0] sec_out,
    output reg [5:0] min_out,
    output reg [4:0] hour_out
);
    reg [31:0] counter; // used to convert clock frequency to 1Hz
    reg prev_increment; // used to detect rising edge of increment

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            sec_out <= 0;
            min_out <= 0;
            hour_out <= 0;
            counter <= 0;
        end
        else begin
            if(counter + 1 > CLK_FREQ_HZ) begin
                counter <= 0;
                if(sec_out + 1 > 59) begin
                    sec_out <= 0;
                    if(min_out + 1 > 59) begin
                        min_out <= 0;
                        if(hour_out + 1 > 23) begin
                            hour_out <= 0;
                        end
                        else hour_out <= hour_out + 1;
                    end
                    else min_out <= min_out + 1;
                end
                else sec_out <= sec_out + 1;
            end
            else counter <= counter + 1;

            if(increment & ~prev_increment) begin // rising edge of increment
                case(select)
                    `SELECT_SEC: sec_out <= 0;
                    `SELECT_MIN: min_out <= min_out + 1 > 59 ? 0 : min_out + 1;
                    `SELECT_HOUR: hour_out <= hour_out + 1 > 23 ? 0 : hour_out + 1;
                endcase
            end
        end
        
        prev_increment <= increment;
    end
endmodule
