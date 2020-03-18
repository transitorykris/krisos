; KrisOS - via.h
; Copyright 2020 Kris Foster

.ifndef _VIA_H_
_VIA_H_ = 1

    .import __VIA1_START__
    .import __VIA2_START__

VIA1_PORTB   = __VIA1_START__ + $0  ; Port B
VIA1_PORTA   = __VIA1_START__ + $1  ; Port A
VIA1_DDRB    = __VIA1_START__ + $2  ; Port B data direction register
VIA1_DDRA    = __VIA1_START__ + $3  ; Port A data direction register
VIA1_T1CL    = __VIA1_START__ + $4  ; Timer 1 low order counter
VIA1_T1CH    = __VIA1_START__ + $5  ; Timer 1 high order counter
VIA1_T1LL    = __VIA1_START__ + $6  ; Timer 1 low order latches
VIA1_T1LH    = __VIA1_START__ + $7  ; Timer 1 high order latches
VIA1_T2CL    = __VIA1_START__ + $8  ; Timer 2 low order counter
VIA1_SR      = __VIA1_START__ + $9  ; Shift register
VIA1_ACR     = __VIA1_START__ + $A  ; Auxilliary control register
VIA1_PCR     = __VIA1_START__ + $B  ; Peripheral control register
VIA1_IFR     = __VIA1_START__ + $C  ; Interrupt flag register
VIA1_IER     = __VIA1_START__ + $D  ; Interrupt enable register
VIA1_ORA     = __VIA1_START__ + $E  ; Port A without handshake

; The K64 will have two VIAs, the ports for the second are unknown right now
VIA2_PORTB   = __VIA2_START__ + $0  ; Port B
VIA2_PORTA   = __VIA2_START__ + $1  ; Port A
VIA2_DDRB    = __VIA2_START__ + $2  ; Port B data direction register
VIA2_DDRA    = __VIA2_START__ + $3  ; Port A data direction register
VIA2_T1CL    = __VIA2_START__ + $4  ; Timer 1 low order counter
VIA2_T1CH    = __VIA2_START__ + $5  ; Timer 1 high order counter
VIA2_T1LL    = __VIA2_START__ + $6  ; Timer 1 low order latches
VIA2_T1LH    = __VIA2_START__ + $7  ; Timer 1 high order latches
VIA2_T2CL    = __VIA2_START__ + $8  ; Timer 2 low order counter
VIA2_SR      = __VIA2_START__ + $9  ; Shift register
VIA2_ACR     = __VIA2_START__ + $A  ; Auxilliary control register
VIA2_PCR     = __VIA2_START__ + $B  ; Peripheral control register
VIA2_IFR     = __VIA2_START__ + $C  ; Interrupt flag register
VIA2_IER     = __VIA2_START__ + $D  ; Interrupt enable register
VIA2_ORA     = __VIA2_START__ + $E  ; Port A without handshake

.endif