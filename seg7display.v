`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Author: github.com/oezeb
// 
// Module Name: Seg7Display
// Project Name: Digital Clock
// Creation Date: 2023-12-13
// Description: Module to display the time on the 7-segment display of the Nexys 4 DDR.
//
//////////////////////////////////////////////////////////////////////////////////

module Seg7Display#(parameter CLK_FREQ_HZ = `KILO)( // CLK_FREQ_HZ >= 1KHz
    input clk, reset,
    input [5:0] sec,
    input [5:0] min,
    input [4:0] hour,
    output CA, CB, CC, CD, CE, CF, CG,
    output reg [7:0] AN
);
    reg [31:0] counter; // used to convert clock frequency to 500Hz
    wire [31:0] threshold = CLK_FREQ_HZ / 500;

    reg [3:0] data;

    // bin to bcd
    wire [7:0] sec_bcd;
    wire [7:0] min_bcd;
    wire [7:0] hour_bcd;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            counter <= 0;
            AN <= 8'b11111110;
        end
        else begin
            if(counter + 1 > threshold) begin
                counter <= 0;
                case(AN)
                    8'b11011111: begin
                        AN <= 8'b11111110;
                        data <= sec_bcd[3:0];
                    end
                    8'b11111110: begin
                        AN <= 8'b11111101;
                        data <= sec_bcd[7:4];
                    end
                    8'b11111101: begin
                        AN <= 8'b11111011;
                        data <= min_bcd[3:0];
                    end
                    8'b11111011: begin
                        AN <= 8'b11110111;
                        data <= min_bcd[7:4];
                    end
                    8'b11110111: begin
                        AN <= 8'b11101111;
                        data <= hour_bcd[3:0];
                    end
                    8'b11101111: begin
                        AN <= 8'b11011111;
                        data <= hour_bcd[7:4];
                    end
                    default: begin
                        AN <= 8'b11111111;
                        data <= 0;
                    end
                endcase
            end
            else counter <= counter + 1;
        end
    end
    
    Seg7Decoder decoder(
        .in(data),
        .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG)
    );

    Bin2BCD Bin2BCD_sec(
        .bin(sec),
        .bcd(sec_bcd)
    );

    Bin2BCD Bin2BCD_min(
        .bin(min),
        .bcd(min_bcd)
    );

    Bin2BCD Bin2BCD_hour(
        .bin(hour),
        .bcd(hour_bcd)
    );
endmodule
