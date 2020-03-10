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
    .import ACIA_DATA
    .import ACIA_STATUS

    .code

user_code_segment = $1000

reset:
    JSR acia_init
    JSR setup_term

    LDA #$00
    LDX #$00
clear_page:
    STA user_code_segment,X
    CPX #$FF
    BEQ clear_done
    INX
    JMP clear_page
clear_done:

load_program:
    JSR XModemRcv

start_program:
    LDA #<calling_msg
    STA $00
    LDA #>calling_msg
    STA $01  
    JSR write
    JSR user_code_segment

get_next_command:
    JSR read

calling_msg: .byte "Starting",CR,LF,LF,LF,NULL

halt:
    JMP halt

nmi:
    RTI

irq:
    ;JSR panic
    ;JSR halt
    RTI

    .segment "VECTORS"
    .word nmi
    .word reset
    .word irq