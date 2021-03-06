; KrisOS - via.h
;
; Copyright 2020 Kris Foster
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

.ifndef _VIA_H_
_VIA_H_ = 1

    .import __VIA1_START__
    .import __VIA2_START__

VIA1_PORTB  = __VIA1_START__ + $0   ; Port B
VIA1_PORTA  = __VIA1_START__ + $1   ; Port A
VIA1_DDRB   = __VIA1_START__ + $2   ; Port B data direction register
VIA1_DDRA   = __VIA1_START__ + $3   ; Port A data direction register
VIA1_T1CL   = __VIA1_START__ + $4   ; Timer 1 low order counter
VIA1_T1CH   = __VIA1_START__ + $5   ; Timer 1 high order counter
VIA1_T1LL   = __VIA1_START__ + $6   ; Timer 1 low order latches
VIA1_T1LH   = __VIA1_START__ + $7   ; Timer 1 high order latches
VIA1_T2CL   = __VIA1_START__ + $8   ; Timer 2 low order counter
VIA1_T2CH   = __VIA1_START__ + $9   ; Timer 2 high order counter
VIA1_SR     = __VIA1_START__ + $A   ; Shift register
VIA1_ACR    = __VIA1_START__ + $B   ; Auxilliary control register
VIA1_PCR    = __VIA1_START__ + $C   ; Peripheral control register
VIA1_IFR    = __VIA1_START__ + $D   ; Interrupt flag register
VIA1_IER    = __VIA1_START__ + $E   ; Interrupt enable register
VIA1_ORA    = __VIA1_START__ + $F   ; Port A without handshake

; The K64 will have two VIAs, the ports for the second are unknown right now
VIA2_PORTB  = __VIA2_START__ + $0   ; Port B
VIA2_PORTA  = __VIA2_START__ + $1   ; Port A
VIA2_DDRB   = __VIA2_START__ + $2   ; Port B data direction register
VIA2_DDRA   = __VIA2_START__ + $3   ; Port A data direction register
VIA2_T1CL   = __VIA2_START__ + $4   ; Timer 1 low order counter
VIA2_T1CH   = __VIA2_START__ + $5   ; Timer 1 high order counter
VIA2_T1LL   = __VIA2_START__ + $6   ; Timer 1 low order latches
VIA2_T1LH   = __VIA2_START__ + $7   ; Timer 1 high order latches
VIA2_T2CL   = __VIA2_START__ + $8   ; Timer 2 low order counter
VIA2_T2CH   = __VIA2_START__ + $9   ; Timer 2 high order counter
VIA2_SR     = __VIA2_START__ + $A   ; Shift register
VIA2_ACR    = __VIA2_START__ + $B   ; Auxilliary control register
VIA2_PCR    = __VIA2_START__ + $C   ; Peripheral control register
VIA2_IFR    = __VIA2_START__ + $D   ; Interrupt flag register
VIA2_IER    = __VIA2_START__ + $E   ; Interrupt enable register
VIA2_ORA    = __VIA2_START__ + $F   ; Port A without handshake

.endif