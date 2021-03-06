; KrisOS Standard Library
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

.ifndef _LIB_STD_
_LIB_STD_ = 1

    .setcpu "6502"
    .psc02                      ; Enable 65c02 opcodes

    .include "../term/term.inc"
    .include "../io/acia.inc"
    .include "../config.inc"

    .importzp string_ptr

    .export write

    .segment "STDLIB"

write:
    PHY
    LDY #00
next_char:
.ifdef CFG_WDC_ACIA
    PHX
    LDX #$00
delay_loop:
    CPX #$FF
    BEQ delay_loop_done
    INX
    JMP delay_loop
delay_loop_done:
.else
wait_txd_empty:
    LDA ACIA_STATUS
    AND #$10
    BEQ wait_txd_empty
.endif
    LDA (string_ptr), y
    BEQ write_done
    STA ACIA_DATA
    CPY #$FF                    ; Are we crossing a page boundary?
    BEQ cross_page
    INY                         ; Nope, increment index
    JMP next_char
cross_page:
    INC string_ptr+1            ; Move to the next page
    LDY #$00                    ; Reset our index
    JMP next_char
write_done:
    PLY
    RTS

.endif