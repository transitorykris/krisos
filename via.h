; KrisOS - via.h
; Copyright 2020 Kris Foster

VIA1_PORTB   = $6000             ; Port B
VIA1_PORTA   = $6001             ; Port A
VIA1_DDRB    = $6002             ; Port B data direction register
VIA1_DDRA    = $6003             ; Port A data direction register
VIA1_T1CL    = $6004             ; Timer 1 low order counter
VIA1_T1CH    = $6005             ; Timer 1 high order counter
VIA1_T1LL    = $6006             ; Timer 1 low order latches
VIA1_T1LH    = $6007             ; Timer 1 high order latches
VIA1_T2CL    = $6008             ; Timer 2 low order counter
VIA1_SR      = $600A             ; Shift register
VIA1_ACR     = $600B             ; Auxilliary control register
VIA1_PCR     = $600C             ; Peripheral control register
VIA1_IFR     = $600D             ; Interrupt flag register
VIA1_IER     = $600E             ; Interrupt enable register
VIA1_ORA     = $6001             ; Port A without handshake

; The K64 will have two VIAs, the ports for the second are unknown right now
VIA2_PORTB   = $6000             ; Port B
VIA2_PORTA   = $6001             ; Port A
VIA2_DDRB    = $6002             ; Port B data direction register
VIA2_DDRA    = $6003             ; Port A data direction register
VIA2_T1CL    = $6004             ; Timer 1 low order counter
VIA2_T1CH    = $6005             ; Timer 1 high order counter
VIA2_T1LL    = $6006             ; Timer 1 low order latches
VIA2_T1LH    = $6007             ; Timer 1 high order latches
VIA2_T2CL    = $6008             ; Timer 2 low order counter
VIA2_SR      = $600A             ; Shift register
VIA2_ACR     = $600B             ; Auxilliary control register
VIA2_PCR     = $600C             ; Peripheral control register
VIA2_IFR     = $600D             ; Interrupt flag register
VIA2_IER     = $600E             ; Interrupt enable register
VIA2_ORA     = $6001             ; Port A without handshake