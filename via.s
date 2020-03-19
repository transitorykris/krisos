; KrisOS VIA Library
; Copyright 2020 Kris Foster

.ifndef _LIB_VIA_
_LIB_VIA_ = 1

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "via.inc"

    .export via1_init_ports
    .export via2_init_ports

; Takes:
; A - data direction for port A
; X - data direction for port B
via1_init_ports:
    STA VIA1_DDRA
    STX VIA1_DDRB
    STZ VIA1_PORTA              ; Set all port outputs to low
    STZ VIA1_PORTB              ; Set all port outputs to low
    RTS

; Takes:
; A - data direction for port A
; X - data direction for port B
via2_init_ports:
    STA VIA2_DDRA
    STX VIA2_DDRB
    STZ VIA2_PORTA              ; Set all port outputs to low
    STZ VIA2_PORTB              ; Set all port outputs to low
    RTS

.endif