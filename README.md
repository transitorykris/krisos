# KrisOS

An operating system for the K64

![Screenshot](https://raw.githubusercontent.com/transitorykris/krisos/master/documentation/screenshot.png)

## Dependencies

 * Requires ca65 and ld65 to build
 * This will only run on a WDC 65c02 CPU
 * `make terminal` uses picoterm, but any terminal software will do

## The Hardware

This is based off a [Ben Eater 6502 Single Board Computer](https://eater.net/6502).

The K64 adds a (non-WDC) 6551 ACIA for serial communication.

## Building

```
$ make
```

And copy `kernel.bin` to your EEPROM.

## Usage

See output of the `help` command.

## License

Unless otherwise noted in the source code, this software:

Copyright 2020 Kris Foster

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
