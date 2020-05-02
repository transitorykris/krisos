; KrisOS Sound Library
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

.ifndef _LIB_SID_
_LIB_SID_ = 1

    .setcpu "6502"
    .psc02                      ; Enable 65c02 opcodes

    .include "sid.inc"

    .export sid_init

sid_init:
    JSR sid_test
    RTS

sid_test:
    LDA #$09
    STA SID_VOICE1_AD
    LDA #$8A
    STA SID_VOICE1_SR
    LDA #$0f
    STA SID_FILTER_MV
    LDA #$20
    STA SID_VOICE1_CTRL_REG
    LDA #$00
    STA SID_FILTER_MV
    LDA #>c5n
    STA SID_VOICE1_FREQ_HI
    LDA #<c5n
    STA SID_VOICE1_FREQ_LO
    LDA #$21
    STA SID_VOICE1_CTRL_REG
    RTS

.endif