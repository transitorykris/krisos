; KrisOS ACIA Library
; Copyright 2020 Kris Foster

.ifndef _LIB_ACIA_
_LIB_ACIA_ = 1

; 6551 ACIA
    .export ACIA_DATA       = $4000
    .export ACIA_STATUS     = $4001
ACIA_COMMAND    = $4002
ACIA_CONTROL    = $4003

    .segment "LIB"

; Set up 6551 ACIA
    .export acia_init
acia_init:
    LDA #%00001011              ; No parity, no echo, no interrupt
    STA ACIA_COMMAND
    LDA #%00011111              ; 1 stop bit, 8 data bits, 19200 baud
    STA ACIA_CONTROL
    RTS

.endif