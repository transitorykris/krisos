; KrisOS ACIA Library
; Copyright 2020 Kris Foster

.ifndef _LIB_ACIA_
_LIB_ACIA_ = 1

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "acia.h"

    .export acia_init

    .segment "LIB"

; Set up 6551 ACIA
acia_init:
    PHA
    STZ ACIA_STATUS             ; Soft reset
    LDA ACIA_DATA               ; Clear errors
    LDA #%00001011              ; No parity, no echo, no interrupt
    STA ACIA_COMMAND
    LDA #%00011111              ; 1 stop bit, 8 data bits, 19200 baud
    STA ACIA_CONTROL
    PLA
    RTS

.endif