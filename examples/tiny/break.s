; KrisOS - break.s
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
; Demonstrates how to create user definable IRQs

    .include "stdlib.inc"

.macro writeln str_addr
    LDA #<str_addr
    STA string_ptr
    LDA #>str_addr
    STA string_ptr+1
    JSR write
.endmacro

LF      = $0a
NULL    = $00
CR      = $0d

string_ptr = $00

    .code

main:
    LDA #<irq_handler
    STA irq_ptr
    LDA #>irq_handler
    STA irq_ptr+1               ; Set the location of our IRQ handler

    writeln brk_msg
    BRK
    .byte $00                   ; Padding required for proper return address
    writeln returned_msg
    RTS                         ; Return control to KrisOS

irq_handler:
    writeln handler_msg
    RTI

brk_msg:        .byte "Generating a BRK",CR,LF,NULL
handler_msg:    .byte "Inside of the IRQ handler",CR,LF,NULL
returned_msg:   .byte "Returned from IRQ",CR,LF,NULL
