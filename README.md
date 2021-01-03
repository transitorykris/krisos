# Not under active development

Hi all! This project comes up from time to time in the [Ben Eater Reddit](https://www.reddit.com/r/beneater/). I'd love to provide support, but my time is limited.

If you're looking for an active project I'd suggest looking at [Dawid Buchwald's DB6502 and OS1](https://github.com/dbuchwald/6502).

For now, I'm exploring the Motorola 68010 with a [Rosco-m68k](https://rosco-m68k.com/) and hacking my way through a [pre-emptive multitasking kernel](https://github.com/transitorykris/kris68k) and hopefully eventually a proper OS.

# KrisOS

An operating system for the K64

![Screenshot](https://raw.githubusercontent.com/transitorykris/krisos/master/documentation/screenshot.png)

## Dependencies

 * Requires ca65 and ld65 to build
 * This will only run on a WDC 65c02 CPU
 * `make terminal` uses picoterm, but any terminal software will do

## The Hardware

This is based off a [Ben Eater 6502 Single Board Computer](https://eater.net/6502).

The K64 adds:
 * a (non-WDC) 6551 ACIA for serial communication, 1.84323 Mhz oscillator, and a TTL to serial interface
 * a second 6522 VIA
 * two additional 74HC00Ns for address decoding
 * a TI SN7689A sound generator, 4Mhz oscillator, and a headphone jack
 * IRQB on VIA1 is connected to the 6502's NMI (assuming you want an uptime counter)

## Building

Modify the `krisos.cfg` memory layout to match your system. If you're using a
Ben Eater 6502 you can find a typical memory layout in `be6502.cfg`, simply
rename that file to `krisos.cfg`.

Modify `config.inc` as needed.

```
$ make
```

And copy `kernel.bin` to your EEPROM.

## Usage

See output of the `help` command.

## The K64

![K64 Photo](https://raw.githubusercontent.com/transitorykris/krisos/master/documentation/k64.png)

## License

Unless otherwise noted in the source code, this software:

Copyright 2020 Kris Foster

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
