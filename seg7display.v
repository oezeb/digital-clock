`include "constants.vh"

module Seg7Display#(parameter CLK_FREQ_HZ = `KILO)( // CLK_FREQ_HZ >= 1KHz
    input clk, reset,
    input [31:0] all_data,
    output CA, CB, CC, CD, CE, CF, CG,
    output reg [7:0] AN
);
    reg [31:0] counter;
    wire [31:0] threshold = CLK_FREQ_HZ / 500;

    reg [3:0] data;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            counter <= 0;
            AN <= 8'b11111110;
        end
        else begin
            if(counter + 1 > threshold) begin
                counter <= 0;
                case(AN)
                    8'b11111110: begin
                        AN <= 8'b11111101;
                        data <= all_data[7:4];
                    end
                    8'b11111101: begin
                        AN <= 8'b11111011;
                        data <= all_data[11:8];
                    end
                    8'b11111011: begin
                        AN <= 8'b11110111;
                        data <= all_data[15:12];
                    end
                    8'b11110111: begin
                        AN <= 8'b11101111;
                        data <= all_data[19:16];
                    end
                    8'b11101111: begin
                        AN <= 8'b11011111;
                        data <= all_data[23:20];
                    end
                    8'b11011111: begin
                        AN <= 8'b10111111;
                        data <= all_data[27:24];
                    end
                    8'b10111111: begin
                        AN <= 8'b01111111;
                        data <= all_data[31:28];
                    end
                    8'b01111111: begin
                        AN <= 8'b11111110;
                        data <= all_data[3:0];
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
endmodule
