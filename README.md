# Multi-Function Digital Clock

This project is a multi-function digital clock implemented on a [Nexys 4 DDR](https://digilent.com/reference/programmable-logic/nexys-4-ddr/start) board. The clock includes a 24-hour format, a timer, and an alarm function.

## Features

- 24-hour clock: Displays the current time in a 24-hour format.
- Timer: Allows you to set a countdown timer.
- Alarm: Allows you to set an alarm for a specific time.

## Hardware Requirements

- Nexys 4 DDR board

## Software Requirements

- Xilinx Vivado for FPGA programming

## Setup and Installation

1. Clone this repository to your local machine.
2. Create a new project in Xilinx Vivado.
3. Add the source files to the project.
4. Generate a bitstream file.
5. Program the Nexys 4 DDR board with the bitstream file.

## Usage

### System inputs

- `CPU_RESET` will reset the system.
- Use the right button(`BTNR`) to switch between the clock, timer, and alarm modes.
- Use the up button(`BTNU`) to increment the selected time unit(hour, minute, second, or none).
- Use the down button(`BTND`) to switch between the time units.
- Use the left button(`BTNL`) to enable/disable the alarm.
- Use the center button(`BTNC`) to start/stop the timer.

### System outputs

- The seven-segment displays will display the time in a 24-hour format based on the current mode.
- `LED0` and `LED1` display the current mode.
- `LED2` and `LED3` display the selected time unit.
- `LED4` displays timer enable/disable.
- `LED5` displays timer reached zero.
- `MONO_AUDIO_OUT` makes some noise when the timer reaches zero.
- `LED6` displays alarm enable/disable.
- `LED7` displays alarm triggered or not.
- `MONO_AUDIO_OUT` makes some noise when the alarm is triggered.
- `LED8` through `LED15` display the seconds in binary based on the current mode.

## License

This project is licensed under the MIT License. See the LICENSE file for details.