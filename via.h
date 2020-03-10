; KrisOS - via.h
; Copyright 2020 Kris Foster

VIA_PORTB   = $6000             ; Port B
VIA_PORTA   = $6001             ; Port A
VIA_DDRB    = $6002             ; Port B data direction register
VIA_DDRA    = $6003             ; Port A data direction register
VIA_T1CL    = $6004             ; Timer 1 low order counter
VIA_T1CH    = $6005             ; Timer 1 high order counter
VIA_T1LL    = $6006             ; Timer 1 low order latches
VIA_T1LH    = $6007             ; Timer 1 high order latches
VIA_T2CL    = $6008             ; Timer 2 low order counter
VIA_SR      = $600A             ; Shift register
VIA_ACR     = $600B             ; Auxilliary control register
VIA_PCR     = $600C             ; Peripheral control register
VIA_IFR     = $600D             ; Interrupt flag register
VIA_IER     = $600E             ; Interrupt enable register
VIA_ORA     = $6001             ; Port A without handshake