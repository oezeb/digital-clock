`include "constants.vh"
//////////////////////////////////////////////////////////////////////////////////
// Author: github.com/oezeb
// 
// Module Name: Top
// Project Name: Digital Clock
// Creation Date: 2023-12-13
// Description: Top level module for the digital clock project. This module is 
//            built to run on the Nexys 4 DDR board.
//
//////////////////////////////////////////////////////////////////////////////////

module Top(
    input CLK100MHZ, CPU_RESETN,
    input BTNC, BTNU, BTNL, BTNR, BTND,

    output [15:0] LED,
    output CA, CB, CC, CD, CE, CF, CG,
    output [7:0] AN,
    output reg AUD_PWM // alarm out and timer out audio
);
    reg PREV_BTNC;
    // reg PREV_BTNU;
    reg PREV_BTNL;
    reg PREV_BTNR;
    reg PREV_BTND;

    // digital clock
    wire reset;
    reg [1:0] mode;
    reg [1:0] select;
    wire increment;
    reg alarm_enable;
    reg timer_enable;

    wire [5:0] sec_out;
    wire [5:0] min_out;
    wire [4:0] hour_out;
    wire alarm_out, timer_out;

    // 1.5KHz clock for audio
    reg [31:0] counter;
    wire [31:0] threshold = 100 * `MEGA / 1500;

    // assign
    assign reset = ~CPU_RESETN;
    assign increment = BTNU;

    assign LED[1:0] = mode;
    assign LED[3:2] = select;
    assign LED[4] = timer_enable;
    assign LED[5] = timer_out;
    assign LED[6] = alarm_enable;
    assign LED[7] = alarm_out;
    assign LED[15:8] = sec_out;

    always @(posedge CLK100MHZ or posedge reset) begin
        if(reset) begin
            AUD_PWM <= 0;
            timer_enable <= 0;
            select <= `SELECT_NONE;
            counter <= 0;
        end
        else begin
            if(counter + 1 > threshold) begin
                counter <= 0;
                if(alarm_out | timer_out) begin
                    AUD_PWM <= ~AUD_PWM;
                    if(alarm_out) begin
                        mode <= `MODE_ALARM;
                        select <= `SELECT_NONE;
                    end
                    else begin
                        mode <= `MODE_TIMER;
                        select <= `SELECT_NONE;
                    end
                end
                else AUD_PWM <= 0;
            end
            else counter <= counter + 1;

            if(BTNC & ~PREV_BTNC & mode == `MODE_TIMER) begin
                timer_enable <= ~timer_enable;
            end

            if(BTNR & ~PREV_BTNR) begin
                case(mode)
                    `MODE_CLOCK: begin
                        mode <= `MODE_TIMER;
                        select <= `SELECT_SEC;
                    end
                    `MODE_TIMER: begin
                        mode <= `MODE_ALARM;
                        select <= `SELECT_SEC;
                    end
                    `MODE_ALARM: begin
                        mode <= `MODE_CLOCK;
                        select <= `SELECT_NONE;
                    end
                endcase
            end

            if(BTNL & ~PREV_BTNL) begin
                alarm_enable <= ~alarm_enable;
            end

            if(BTND & ~PREV_BTND) begin
                case(select)
                    `SELECT_NONE: select <= `SELECT_SEC;
                    `SELECT_SEC: select <= `SELECT_MIN;
                    `SELECT_MIN: select <= `SELECT_HOUR;
                    `SELECT_HOUR: select <= `SELECT_NONE;
                endcase
            end
        end

        PREV_BTNC <= BTNC;
        // PREV_BTNU <= BTNU;
        PREV_BTNL <= BTNL;
        PREV_BTNR <= BTNR;
        PREV_BTND <= BTND;
    end

    DigitalClock #(100 * `MEGA) DigitalClock(
        .clk(CLK100MHZ),
        .reset(reset),
        .mode(mode),
        .select(select),
        .increment(increment),
        .alarm_enable(alarm_enable),
        .timer_enable(timer_enable),
        .sec_out(sec_out),
        .min_out(min_out),
        .hour_out(hour_out),
        .alarm_out(alarm_out),
        .timer_out(timer_out)
    );

    Seg7Display #(100 * `MEGA) Seg7Display(
        .clk(CLK100MHZ),
        .reset(reset),
        .sec(sec_out),
        .min(min_out),
        .hour(hour_out),
        .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG),
        .AN(AN)
    );
endmodule
