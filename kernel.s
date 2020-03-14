; KrisOS for the K64
; Copyright 2020 Kris Foster

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "term.h"

; External imports
    .import acia_init
    .import XModemRcv
    .import setup_term
    .import read
    .import write
    .import panic
    .import reset_user_input
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
    JSR parse
    ; Parse command
    ; Error if bad command
    ; Execute command
    ;JMP repl                    ; Get our next command

load_program:
    JSR XModemRcv               ; Retrieve a file using xmodem

start_program:
    writeln calling_msg         ; Indicate that we're starting the user's code
    JSR user_code_segment       ; Start it!

get_next_command:
    JSR read                    ; Read in our next command

calling_msg: .byte "Starting",CR,LF,LF,LF,NULL

halt:
    JMP halt

nmi:
    RTI

irq:
    RTI

    .segment "VECTORS"
    .word nmi
    .word reset
    .word irq