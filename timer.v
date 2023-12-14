`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Author: github.com/oezeb
// 
// Module Name: Timer
// Project Name: Digital Clock
// Creation Date: 2023-12-11
// Description: Implements a timer. The `select` and `increment` inputs can be used
//             to edit the time(`sec_out`, `min_out`, `hour_out`). When the timer
//             reaches 0, the `out` output is high.
//
//////////////////////////////////////////////////////////////////////////////////

module Timer#(parameter CLK_FREQ_HZ = `KILO)( // CLK_FREQ_HZ >= 1Hz
    input clk, reset, enable,

    input [1:0] select,
    input increment,

    output reg [5:0] sec_out,
    output reg [5:0] min_out,
    output reg [4:0] hour_out,

    output reg out
);
    reg [31:0] counter; // used to convert clock frequency to 1Hz
    reg prev_increment; // used to detect rising edge of increment

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            sec_out <= 0;
            min_out <= 0;
            hour_out <= 0;
            out <= 0;
            counter <= 0;
        end
        else if(enable) begin
            // keep timer `out` signal high until the user sets the `enable` input to 0
            if(~out) begin
                out <= sec_out == 0 & min_out == 0 & hour_out == 0;
                if(counter + 1 > CLK_FREQ_HZ) begin
                    counter <= 0;
                    if(sec_out == 0) begin
                        sec_out <= 59;
                        if(min_out == 0) begin
                            min_out <= 59;
                            if(hour_out == 0) begin
                                hour_out <= 23;
                            end
                            else hour_out <= hour_out - 1;
                        end
                        else min_out <= min_out - 1;
                    end
                    else sec_out <= sec_out - 1;
                end
                else counter <= counter + 1;
            end
        end
        else begin
            out <= 0;
            if(increment & ~prev_increment) begin // rising edge of increment
                counter <= 0;
                case(select)
                    `SELECT_SEC: sec_out <= sec_out + 1 > 59 ? 0 : sec_out + 1;
                    `SELECT_MIN: min_out <= min_out + 1 > 59 ? 0 : min_out + 1;
                    `SELECT_HOUR: hour_out <= hour_out + 1 > 23 ? 0 : hour_out + 1;
                endcase
            end
        end
        
        prev_increment <= increment;
    end
endmodule
