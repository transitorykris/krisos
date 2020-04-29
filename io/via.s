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
    .psc02                      ; Enable 65c02 opcodes

    .include "via.inc"

    .export via1_init_ports
    .export via2_init_ports
    .export test_via1
    .export test_via2

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

; Success carry clear
; Failure carry set
test_via1:
    LDA VIA1_DDRA               ; Save our direction registers
    PHA
    LDA VIA1_DDRB
    PHA

    LDA #$FF                    ; Set both direction registers to output
    STA VIA1_DDRA
    STA VIA1_DDRB

    LDA $A5                     ; First pattern
    STA VIA1_PORTA
    CMP VIA1_PORTA
    BNE test_via1_failed
    STA VIA1_PORTB
    BNE test_via1_failed

    LDA $5A                     ; Second pattern
    STA VIA1_PORTA
    CMP VIA1_PORTA
    BNE test_via1_failed
    STA VIA1_PORTB
    BNE test_via1_failed

    PLA                         ; Restore our direction registers
    STA VIA1_DDRB
    PLA
    STA VIA1_DDRA
    CLC                         ; Set success
    RTS
test_via1_failed:
    SEC                         ; Set failure
    RTS

test_via2:
    LDA VIA2_DDRA               ; Save our direction registers
    PHA
    LDA VIA2_DDRB
    PHA

    LDA #$FF
    STA VIA2_DDRA
    STA VIA2_DDRB

    LDA $A5                     ; First pattern
    STA VIA2_PORTA
    CMP VIA2_PORTA
    BNE test_via2_failed
    STA VIA2_PORTB
    BNE test_via2_failed

    LDA $5A                     ; Second pattern
    STA VIA2_PORTA
    CMP VIA2_PORTA
    BNE test_via2_failed
    STA VIA2_PORTB
    BNE test_via2_failed

    PLA                         ; Restore our direction registers
    STA VIA2_DDRB
    PLA
    STA VIA2_DDRA
    CLC                         ; Set success
    RTS
test_via2_failed:
    SEC                         ; Set failure
    RTS

.endif