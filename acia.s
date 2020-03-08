; KrisOS ACIA Library
; Copyright 2020 Kris Foster

.ifndef _LIB_ACIA_
_LIB_ACIA_ = 1

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

; Exported symbols
    .export ACIA_DATA
    .export ACIA_STATUS
    .export acia_init

; 6551 ACIA
ACIA_DATA       = $4000
ACIA_STATUS     = $4001
ACIA_COMMAND    = $4002
ACIA_CONTROL    = $4003

    .segment "LIB"

; Set up 6551 ACIA
acia_init:
    LDA #%00001011              ; No parity, no echo, no interrupt
    STA ACIA_COMMAND
    LDA #%00011111              ; 1 stop bit, 8 data bits, 19200 baud
    STA ACIA_CONTROL
    RTS

.endif