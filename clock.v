`include "constants.v"

module Clock(
    input clk100MHz, reset,

    input [1:0] select,
    input increment,

    output reg [5:0] sec_out,
    output reg [5:0] min_out,
    output reg [4:0] hour_out
);
    wire clk1Hz;
    reg prev_clk1Hz;
    reg prev_increment;

    always @(posedge clk100MHz or posedge reset) begin
        if(reset) begin
            sec_out <= 0;
            min_out <= 0;
            hour_out <= 0;
        end
        else begin
            if (clk1Hz & ~prev_clk1Hz) begin
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

            if (increment & ~prev_increment) begin
                case(select)
                    `SELECT_SEC: sec_out <= 0;
                    `SELECT_MIN: min_out <= min_out + 1 >= 60 ? 0 : min_out + 1;
                    `SELECT_HOUR: hour_out <= hour_out + 1 >= 24 ? 0 : hour_out + 1;
                endcase
            end
        end
        
        prev_clk1Hz <= clk1Hz;
        prev_increment <= increment;
    end

    ClockConverter #(.FROM_HZ(100000000), .TO_HZ(1)) ClockConverter(
        .clk(clk100MHz),
        .clk_out(clk1Hz)
    );
endmodule
