; KrisOS - command.h
; Copyright 2020 Kris Foster

.ifndef _COMMAND_H_
_COMMAND_H_ = 1

ERROR_CMD = $00
LOAD_CMD = $01
RUN_CMD = $02
DUMP_CMD = $03

FALSE = 0
TRUE = 1

EQUAL = $0
LT = $FF
GT = $1

LOAD: .byte "load",NULL
RUN: .byte "run",NULL
DUMP: .byte "dump",NULL

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