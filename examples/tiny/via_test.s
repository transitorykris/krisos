; KrisOS - via_test.s
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
;
; Fiddles with the VIA ports on the K64

VIA1_PORTB = $A000
VIA1_PORTA = $A001
VIA1_DDRB = $A002
VIA1_DDRA = $A003

VIA2_PORTB = $B000
VIA2_PORTA = $B001
VIA2_DDRB = $B002
VIA2_DDRA = $B003

LF      = $0a
NULL    = $00
CR      = $0d

; Zero Page pointers
string_ptr = $00

    .include "stdlib.inc"

    .code

hello:
    LDA #<test_msg
    STA string_ptr
    LDA #>test_msg
    STA string_ptr+1
    JSR write

ports_on:
    LDA #$FF                    ; Turn all pin output, and on
    STA VIA1_DDRA
    STA VIA1_PORTA
    STA VIA1_DDRB
    STA VIA1_PORTB

    STA VIA2_DDRA
    STA VIA2_PORTA
    STA VIA2_DDRB
    STA VIA2_PORTB

done:
    LDA #<done_msg
    STA string_ptr
    LDA #>done_msg
    STA string_ptr+1
    JSR write

    RTS                         ; Return control to KrisOS

test_msg:  .byte   "Turning LED on", CR, LF, NULL
done_msg:  .byte   "Done!", CR, LF, NULL
not_set_msg: .byte "VIA2 did not appear to set correctly",CR,LF,NULL