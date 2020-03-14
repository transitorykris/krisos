; KrisOS for the K64
; Copyright 2020 Kris Foster

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "term.h"
    .include "command.h"

; External imports
    .import acia_init
    .import XModemRcv
    .import setup_term
    .import read
    .import write
    .import dump
    .import panic
    .import reset_user_input
    .import parse_command
    .import user_input
    .import ACIA_DATA
    .import ACIA_STATUS

    .code

user_code_segment = $1000       ; The user's program will be stored here

reset:
    SEI                         ; Disable interrupts while we initialize
    LDX #$FF                    ; Initialize our stack pointer
    TXS
    CLD                         ; Explicitly do not use decimal mode

    JSR acia_init               ; Set up the serial port
    JSR setup_term              ; Pretty up the user's terminal

    LDA #$00
    LDX #$00
clear_page:                     ; Give the user's code clean space to run in
    STA user_code_segment,X
    CPX #$FF
    BEQ clear_done
    INX
    JMP clear_page
clear_done:

    CLI                         ; Re-enable interrupts

repl:                           ; Not really a repl but I don't have a better name
    ; Show prompt
    JSR reset_user_input

    ; Read command
    writeln new_line
    writeln prompt
    JSR read

    ; Parse command
    JSR parse_command
    CMP #ERROR_CMD
    BEQ error

    ; Execute command
    CMP #LOAD_CMD
    BEQ load_program
    CMP #RUN_CMD
    BEQ run_program
    CMP #DUMP_CMD
    BEQ dump_program
    CMP #HELP_CMD
    BEQ help
    CMP #SHUTDOWN_CMD
    BEQ shutdown

    JMP repl                    ; Do it all again!

error:
    writeln bad_command_msg
    JMP repl

load_program:
    JSR XModemRcv               ; Retrieve a file using xmodem
    JMP repl

run_program:
    writeln calling_msg         ; Indicate that we're starting the user's code
    JSR user_code_segment       ; Start it!
    JMP repl

dump_program:
    JSR dump
    JMP repl

help:
    writeln LOAD_HELP
    writeln RUN_HELP
    writeln DUMP_HELP
    writeln HELP_HELP
    writeln SHUTDOWN_HELP
    JMP repl

shutdown:
    writeln shutdown_msg
    .byte $DB                   ; STP opcode not in ca65?

nmi:
    RTI

irq:
    RTI

calling_msg: .byte "Starting",CR,LF,LF,NULL
bad_command_msg: .byte "Unknown command, type help for help",CR,LF,NULL
shutdown_msg: .byte "Shutting down...",CR,LF,NULL

    .segment "VECTORS"
    .word nmi
    .word reset
    .word irq