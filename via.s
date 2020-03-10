; KrisOS VIA Library
; Copyright 2020 Kris Foster

; Takes:
; A - data direction for port A
; X - data direction for port B
via_init_ports:
    STA VIA_DDRA
    STX VIA_DDRX
    LDA #$00                    ; Set all port outputs to low
    STA PORTA
    STA PORTB
    RTS