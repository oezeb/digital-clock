module Stopwatch(
    input clk, reset, enable,
    
    output reg [6:0] ms_out,
    output reg [5:0] sec_out,
    output reg [5:0] min_out
);
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            ms_out <= 0;
            sec_out <= 0;
            min_out <= 0;
        end
        else if(enable) begin
            if(ms_out + 1 >= 100) begin
                ms_out <= 0;
                if(sec_out + 1 >= 60) begin
                    sec_out <= 0;
                    if(min_out + 1 >= 60) begin
                        min_out <= 0;
                    end
                    else begin
                        min_out <= min_out + 1;
                    end
                end
                else begin
                    sec_out <= sec_out + 1;
                end
            end
            else begin
                ms_out <= ms_out + 1;
            end
        end
    end
endmodule
