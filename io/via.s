; KrisOS VIA Library
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