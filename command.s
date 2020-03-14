; KrisOS Command Library
; Copyright 2020 Kris Foster

.ifndef _LIB_COMMAND_
_LIB_COMMAND_ = 1

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "term.h"
    .include "command.h"

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
check_load:
    LDA #<LOAD
    STA strcmp_second_ptr
    LDA #>LOAD
    STA strcmp_second_ptr+1
    JSR strcmp
    CMP #EQUAL
    BNE check_run
    LDA #LOAD_CMD
    RTS
check_run:
    LDA #<RUN
    STA strcmp_second_ptr
    LDA #>RUN
    STA strcmp_second_ptr+1
    JSR strcmp
    CMP #EQUAL
    BNE check_dump
    LDA #RUN_CMD
    RTS
check_dump:
    LDA #<DUMP
    STA strcmp_second_ptr
    LDA #>DUMP
    STA strcmp_second_ptr+1
    JSR strcmp
    CMP #EQUAL
    BNE error
    LDA #DUMP_CMD
    RTS
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
    LDY #$00
strcmp_load:
    LDA (strcmp_first_ptr), Y
    CMP (strcmp_second_ptr), Y
    BNE strcmp_done
    INY
    CMP #NULL
    BNE strcmp_load
    LDA #EQUAL
    RTS
strcmp_done:
    BCS strcmp_greater
    LDA #LT
    RTS
strcmp_greater:
    LDA #GT
    RTS

.endif