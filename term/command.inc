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

    .feature string_escapes

.enum
    ERROR_CMD
    LOAD_CMD
    RUN_CMD
    DUMP_CMD
    HELP_CMD
    SHUTDOWN_CMD
    EMPTY_CMD
    CLEAR_CMD
    RESET_CMD
    BREAK_CMD
    BEEP_CMD
    UPTIME_CMD
    STACK_CMD
.endenum

FALSE   = 0
TRUE    = 1

EQUAL   = $0
LT      = $FF
GT      = $1

    .RODATA
LOAD:       .asciiz "load"
RUN:        .asciiz "run"
DUMP:       .asciiz "dump"
HELP:       .asciiz "help"
SHUTDOWN:   .asciiz "shutdown"
EMPTY:      .asciiz ""
CLEAR:      .asciiz "clear"
RESET:      .asciiz "reset"
BREAK:      .asciiz "break"
BEEP:       .asciiz "beep"
UPTIME:     .asciiz "uptime"
STACK:      .asciiz "stack"

help_header_msg:        ; Note: this is split up for a chance to fit in page boundaries
    .byte "Available commands in KrisOS:\n\r"
    .byte "------------------------------------------------\n\r"
    .byte NULL

help_commands_msg:
    .byte "load - Begins an XMODEM receive\n\r"
    .byte "run - Starts the program located at $1000\n\r"
    .byte "dump - Displays the first page of data at $1000\n\r"
    .byte "help - Displays this helpful help message\n\r"
    .byte "shutdown - Stop the K64\n\r"
    .byte "clear - Clears the screen\n\r"
    .byte "reset - Soft resets the computer\n\r"
    .byte "break - Trigger a soft IRQ\n\r"
    .byte "beep - Beeps the speaker\n\r"
    .byte "uptime - Show the uptime in seconds of the K64\n\r"
    .byte NULL

help_copyright_msg:
    .byte "------------------------------------------------\n\r"
    .byte "KrisOS is licensed under the MIT License\n\r"
    .byte "Some code contains other copyrights, please see:\n\r"
    .byte "github.com/transitorykris/krisos for details\n\r"
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