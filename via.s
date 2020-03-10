; KrisOS VIA Library
; Copyright 2020 Kris Foster

.ifndef _LIB_VIA_
_LIB_VIA_ = 1

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "via.h"

; Takes:
; A - data direction for port A
; X - data direction for port B
via1_init_ports:
    STA VIA1_DDRA
    STX VIA1_DDRB
    LDA #$00                    ; Set all port outputs to low
    STA VIA1_PORTA
    STA VIA1_PORTB
    RTS

; Takes:
; A - data direction for port A
; X - data direction for port B
via2_init_ports:
    STA VIA2_DDRA
    STX VIA2_DDRB
    LDA #$00                    ; Set all port outputs to low
    STA VIA2_PORTA
    STA VIA2_PORTB
    RTS

.endif