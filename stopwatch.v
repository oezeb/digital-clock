module Stopwatch#(parameter CLK_FREQ_HZ = `KILO)( // CLK_FREQ_HZ >= 1KHz
    input clk, reset, start, stop,
    
    output reg [9:0] ms_out,
    output reg [5:0] sec_out,
    output reg [5:0] min_out
);
    wire clk1KHz;
    reg enable;
    wire start_posedge, stop_posedge;

    always @(posedge clk1KHz or posedge reset) begin
        if(reset) begin
            ms_out <= 0;
            sec_out <= 0;
            min_out <= 0;
        end
        else if(enable) begin
            if(ms_out + 1 > 999) begin
                ms_out <= 0;
                if(sec_out + 1 > 59) begin
                    sec_out <= 0;
                    if(min_out + 1 > 59) begin
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

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            enable <= 0;
        end
        else if(start_posedge) begin
            enable <= 1;
        end
        else if(stop_posedge) begin
            enable <= 0;
        end
    end

    ClockConverter #(CLK_FREQ_HZ,  `KILO) ClockConverter(
        .clk(clk),
        .clk_out(clk1KHz)
    );
    
    PosedgeDetector PosedgeDetector_start(
        .clk(clk),
        .signal(start),
        .out(start_posedge)
    );    

    PosedgeDetector PosedgeDetector_stop(
        .clk(clk),
        .signal(stop),
        .out(stop_posedge)
    );
endmodule
