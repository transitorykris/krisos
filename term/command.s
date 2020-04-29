; KrisOS Command Library
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

.ifndef _LIB_COMMAND_
_LIB_COMMAND_ = 1

    .setcpu "6502"
    .psc02                      ; Enable 65c02 opcodes

    .include "term.inc"
    .include "command.inc"

    .importzp strcmp_first_ptr
    .importzp strcmp_second_ptr

    .import string_ptr
    .import write

    .import user_input

    .export parse_command

    .segment "LIB"

; Returns
; A - command code
parse_command:
    LDA #<user_input
    STA strcmp_first_ptr
    LDA #>user_input
    STA strcmp_first_ptr+1
    check_command LOAD, LOAD_CMD
    check_command RUN, RUN_CMD
    check_command DUMP, DUMP_CMD
    check_command HELP, HELP_CMD
    check_command SHUTDOWN, SHUTDOWN_CMD
    check_command EMPTY, EMPTY_CMD
    check_command CLEAR, CLEAR_CMD
    check_command RESET, RESET_CMD
    check_command BREAK, BREAK_CMD
    check_command BEEP, BEEP_CMD
    check_command UPTIME, UPTIME_CMD
    check_command STACK, STACK_CMD
error:
    LDA #ERROR_CMD
    RTS

; Borrowed from
; http://prosepoetrycode.potterpcs.net/tag/6502/
; Arguments:
; $F0-$F1: First string
; $F2-$F3: Second string
; Returns comparison result in A:
; -1: First string is less than second
; 0: Strings are equal
; 1; First string is greater than second
strcmp:
    PHY
    LDY #$00
strcmp_load:
    LDA (strcmp_first_ptr), Y
    CMP (strcmp_second_ptr), Y
    BNE strcmp_lesser
    INY
    CMP #NULL
    BNE strcmp_load
    LDA #EQUAL
    JMP strcmp_done
strcmp_lesser:
    BCS strcmp_greater
    LDA #LT
    JMP strcmp_done
strcmp_greater:
    LDA #GT
    JMP strcmp_done
strcmp_done:
    PLY
    RTS

.endif