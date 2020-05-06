; KrisOS - kernel.h
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

.ifndef _KERNEL_H_
_KERNEL_H_ = 1

    .feature string_escapes

    .import __USER_START__

TICK = 65335                    ; Who knows how long a second is! This one's fast

user_code_segment = __USER_START__  ; The user's program will be stored here

    .RODATA
krisos_lcd_message: .asciiz "KrisOS/K64"
build_time: .dword .time            ; .time is provided by ca65
assembler_version: .word .version   ; .version is provided by ca65

.macro case_command command,routine
    .local skip
    CMP command
    BNE skip
    JSR routine
    JMP command_line
skip:
.endmacro

.endif