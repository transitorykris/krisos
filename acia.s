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
    LDA #ACIA_HARDWARE_RESET
    STA ACIA_STATUS
    LDA ACIA_DATA               ; Clear errors
    LDA #(ACIA_TX_DIS_RTS_LOW|ACIA_NO_PARITY|ACIA_NO_ECHO|ACIA_IRQ_DISABLE|ACIA_DTR_ENABLE)
    ;LDA #%00001011              ; No parity, no echo, no interrupt
    STA ACIA_COMMAND
    LDA #(ACIA_BAUD_GENERATOR|ACIA_1_STOP_BIT|ACIA_8_DATA_BITS|ACIA_19200_BAUD)
    LDA #%00011111              ; 1 stop bit, 8 data bits, 19200 baud
    STA ACIA_CONTROL
    PLA
    RTS

.endif