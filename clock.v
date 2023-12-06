`include "constants.v"

module Clock#(parameter CLK_FREQ_HZ = `KILO)( // CLK_FREQ_HZ > 1Hz
    input clk, reset,

    input [1:0] select,
    input increment,

    output reg [5:0] sec_out,
    output reg [5:0] min_out,
    output reg [4:0] hour_out
);
    wire clk1Hz;
    wire clk1Hz_posedge;
    wire increment_posedge;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            sec_out <= 0;
            min_out <= 0;
            hour_out <= 0;
        end
        else begin
            if (clk1Hz_posedge) begin
                if(sec_out + 1 > 59) begin
                    sec_out <= 0;
                    if(min_out + 1 > 59) begin
                        min_out <= 0;
                        hour_out <= hour_out + 1 > 23 ? 0 : hour_out + 1;
                    end
                    else begin
                        min_out <= min_out + 1;
                    end
                end
                else begin
                    sec_out <= sec_out + 1;
                end
            end

            if (increment_posedge) begin
                case(select)
                    `SELECT_SEC: sec_out <= 0;
                    `SELECT_MIN: min_out <= min_out + 1 > 59 ? 0 : min_out + 1;
                    `SELECT_HOUR: hour_out <= hour_out + 1 > 23 ? 0 : hour_out + 1;
                endcase
            end
        end
    end

    ClockConverter #(CLK_FREQ_HZ, 1) ClockConverter(
        .clk(clk),
        .clk_out(clk1Hz)
    );

    PosedgeDetector PosedgeDetector_clk1Hz(
        .clk(clk),
        .signal(clk1Hz),
        .out(clk1Hz_posedge)
    );

    PosedgeDetector PosedgeDetector_increment(
        .clk(clk),
        .signal(increment),
        .out(increment_posedge)
    );
endmodule
