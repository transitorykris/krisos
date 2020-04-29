; KrisOS memory test
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

.ifndef _LIB_MEMTEST_
_MEM_TEST_ = 1

    .setcpu "6502"
    .PSC02

    .importzp memset_addr

; This is a desctructive test
; Test all memory in the user space as defined in the linker config
; TODO...
memtest_user:
    JSR memtest
    RTS

; This is a destructive test on a page
; Carry set for failure, carry clear for success
memtest:
memtest_pattern_a5:             ; First pattern #$A5
    LDA #%10101010
    JSR memset
    LDY #$FF
memtest_a5_loop:
    CMP memset_addr,Y           ; Compare memory location to #$A5
    BNE memtest_fail
    DEY
    BEQ memtest_pattern_5a
    JMP memtest_a5_loop
memtest_pattern_5a:             ; Second pattern #$5A
    LDA #%01010101
    JSR memset
    LDY #$FF
memtest_5a_loop:
    CMP memset_addr,Y           ; Compare memory location to #$5A
    BNE memtest_fail
    DEY
    BEQ memtest_success
    JMP memtest_5a_loop
memtest_success:
    CLC                         ; Success
    RTS
memtest_fail:
    SEC                         ; Fail
    RTS

; Sets all bytes in a page to the value in the A register
; Page must be set at memset_addr in the zero page
memset:
    LDX #$FF
memset_loop:
    STA memset_addr,X
    DEX
    BNE memset_loop
    RTS

.endif