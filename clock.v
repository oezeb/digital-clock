module Clock(
    input clk, set, reset,
    input [5:0] sec_in,
    input [5:0] min_in,
    input [4:0] hour_in,

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
                    if(hour_out + 1 >= 24) begin
                        hour_out <= 0;
                    end
                    else begin
                        hour_out <= hour_out + 1;
                    end
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
endmodule
