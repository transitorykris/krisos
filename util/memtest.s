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
    .psc02                      ; Enable 65c02 opcodes

    .importzp memset_addr
    
    .export memtest_user
    .export clear_page

; This is a desctructive test
; Test all memory in the user space as defined in the linker config
; TODO...
memtest_user:
    LDA #$00
    STA memset_addr
    LDA #$10
memtest_user_loop:
    STA memset_addr+1
    JSR memtest
    BCS memtest_user_failed
    CMP #$70
    BEQ memtest_user_success
    INC
    JMP memtest_user_loop
memtest_user_failed:
    SEC
    RTS
memtest_user_success:
    CLC
    RTS

clear_page:
    STA memset_addr+1
    PHA                         ; In case the user wants that value after
    LDA #$00
    STA memset_addr
    JSR memset
    PLA
    RTS

; This is a destructive test on a page
; Carry set for failure, carry clear for success
memtest:
    PHA
memtest_pattern_a5:             ; First pattern #$A5
    LDA #$A5
    JSR memset
    LDY #$00
memtest_a5_loop:
    CMP (memset_addr),Y         ; Compare memory location to #$A5
    BNE memtest_fail
    DEY
    BEQ memtest_pattern_5a
    JMP memtest_a5_loop
memtest_pattern_5a:             ; Second pattern #$5A
    LDA #$5A
    JSR memset
    LDY #$00
memtest_5a_loop:
    CMP (memset_addr),Y         ; Compare memory location to #$5A
    BNE memtest_fail
    DEY
    BEQ memtest_success
    JMP memtest_5a_loop
memtest_success:
    CLC                         ; Success
    PLA
    RTS
memtest_fail:
    SEC                         ; Fail
    PLA
    RTS

; Sets all bytes in a page to the value in the A register
; Page must be set at memset_addr in the zero page
memset:
    PHY
    LDY #$00
memset_loop:
    STA (memset_addr),Y
    DEY
    BNE memset_loop
    PLY
    RTS

.endif