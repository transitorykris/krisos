; KrisOS - command.h
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

.ifndef _COMMAND_H_
_COMMAND_H_ = 1

ERROR_CMD       = $00
LOAD_CMD        = $01
RUN_CMD         = $02
DUMP_CMD        = $03
HELP_CMD        = $04
SHUTDOWN_CMD    = $05
EMPTY_CMD       = $06
CLEAR_CMD       = $07
RESET_CMD       = $08
BREAK_CMD       = $09
BEEP_CMD        = $0A
UPTIME_CMD      = $0B
STACK_CMD       = $0C

FALSE   = 0
TRUE    = 1

EQUAL   = $0
LT      = $FF
GT      = $1

    .RODATA
LOAD:       .byte "load",NULL
RUN:        .byte "run",NULL
DUMP:       .byte "dump",NULL
HELP:       .byte "help",NULL
SHUTDOWN:   .byte "shutdown",NULL
EMPTY:      .byte "",NULL
CLEAR:      .byte "clear",NULL
RESET:      .byte "reset",NULL
BREAK:      .byte "break",NULL
BEEP:       .byte "beep",NULL
UPTIME:     .byte "uptime",NULL
STACK:      .byte "stack",NULL

help_header_msg:        ; Note: this is split up for a chance to fit in page boundaries
    .byte "Available commands in KrisOS:",CR,LF
    .byte "------------------------------------------------",CR,LF
    .byte NULL

help_commands_msg:
    .byte "load - Begins an XMODEM receive",CR,LF
    .byte "run - Starts the program located at $1000",CR,LF
    .byte "dump - Displays the first page of data at $1000",CR,LF
    .byte "help - Displays this helpful help message",CR,LF
    .byte "shutdown - Stop the K64",CR,LF
    .byte "clear - Clears the screen",CR,LF
    .byte "reset - Soft resets the computer",CR,LF
    .byte "break - Trigger a soft IRQ",CR,LF
    .byte "beep - Beeps the speaker",CR,LF
    .byte "uptime - Show the uptime in seconds of the K64",CR,LF
    .byte NULL

help_copyright_msg:
    .byte "------------------------------------------------",CR,LF
    .byte "KrisOS is licensed under the MIT License",CR,LF
    .byte "XMODEM Copyright 2002 Daryl Rictor",CR,LF
    .byte "Some ACIA code by Dirk Grappendorf",CR,LF
    .byte "binhex by BigDumbDinosaur on 6502.org",CR,LF
    .byte "strcmp by Michael H. Potter",CR,LF
    .byte "The K64 is based on a design by Ben Eater",CR,LF
    .byte "See github.com/transitorykris/krisos for details",CR,LF
    .byte NULL


; The STP opcode is not available in ca65
.macro STP
    .byte $DB
.endmacro

.macro check_command command, number
    .local next
    LDA #<command
    STA strcmp_second_ptr
    LDA #>command
    STA strcmp_second_ptr+1
    JSR strcmp
    CMP #EQUAL
    BNE next
    LDA #number
    RTS
next:
.endmacro

.endif