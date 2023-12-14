//////////////////////////////////////////////////////////////////////////////////
// Author: github.com/oezeb
// 
// Module Name: Seg7Decoder
// Project Name: Digital Clock
// Creation Date: 2023-12-13
// Description: Converts 4-bit binary to 7-segment display. Only supports 0-9. 
//              The output is active low and is used to turn on/off the segments 
//              as shown below. See Nexys 4 DDR reference manual for more details.
//                    CA
//                   ====
//              CF ||    || CB
//                   ==== CG
//              CE ||    || CC
//                   ====
//                    CD
//
//////////////////////////////////////////////////////////////////////////////////

module Seg7Decoder(
    input [3:0] in,
    output reg CA, CB, CC, CD, CE, CF, CG // active low
);
    always @* begin
        case(in)
            4'b0000: begin // CA, CB, CC, CD, CE, CF
                {CA, CB, CC, CD, CE, CF, CG} <= 7'b0000001;
            end
            4'b0001: begin // CB, CC
                {CA, CB, CC, CD, CE, CF, CG} <= 7'b1001111;
            end
            4'b0010: begin // CA, CB, CD, CE, CG
                {CA, CB, CC, CD, CE, CF, CG} <= 7'b0010010;
            end
            4'b0011: begin // CA, CB, CC, CD, CG
                {CA, CB, CC, CD, CE, CF, CG} <= 7'b0000110;
            end
            4'b0100: begin // CB, CC, CF, CG
                {CA, CB, CC, CD, CE, CF, CG} <= 7'b1001100;
            end
            4'b0101: begin // CA, CC, CD, CF, CG
                {CA, CB, CC, CD, CE, CF, CG} <= 7'b0100100;
            end
            4'b0110: begin // CA, CC, CD, CE, CF, CG
                {CA, CB, CC, CD, CE, CF, CG} <= 7'b0100000;
            end
            4'b0111: begin // CA, CB, CC
                {CA, CB, CC, CD, CE, CF, CG} <= 7'b0001111;
            end
            4'b1000: begin // CA, CB, CC, CD, CE, CF, CG
                {CA, CB, CC, CD, CE, CF, CG} <= 7'b0000000;
            end
            4'b1001: begin // CA, CB, CC, CF, CG
                {CA, CB, CC, CD, CE, CF, CG} <= 7'b0001100;
            end
            default: begin
                {CA, CB, CC, CD, CE, CF, CG} <= 7'b1111111;
            end
        endcase
    end
endmodule
