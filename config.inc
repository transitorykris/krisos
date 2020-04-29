; KrisOS Configuration
;
; Copyright 2020 Kris Foster
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

; This system uses a WDC 6551 ACIA which has a transmit bug
; http://forum.6502.org/viewtopic.php?f=4&t=2543&start=30#p29795
; Leave unset for AMI or Rockwell 6551s
;CFG_WDC_ACIA = 1

; Use the LCD module
;CFG_LCD = 1

; Use the SN76489 sound generator
CFG_SN76489 = 1

; Generate periodic interrupts for the system clock
;CFG_CLOCK = 1

; Enable debug output
;CFG_DEBUG = 1

; Test user space memory
CFG_USER_MEMTEST = 1