; KrisOS - command.h
; Copyright 2020 Kris Foster

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

FALSE   = 0
TRUE    = 1

EQUAL   = $0
LT      = $FF
GT      = $1

LOAD:       .byte "load",NULL
RUN:        .byte "run",NULL
DUMP:       .byte "dump",NULL
HELP:       .byte "help",NULL
SHUTDOWN:   .byte "shutdown",NULL
EMPTY:      .byte "",NULL
CLEAR:      .byte "clear",NULL

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
    .byte NULL

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