; KrisOS - puts.s
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

    .setcpu "6502"
    .PSC02

    .include "bios.inc"

    .export _puts
    .exportzp _char_ptr: near

    .zeropage

_char_ptr:  .res 2, $00      ;  Reserve a local zero page pointer

    .segment  "CODE"

.proc _puts: near
    STA _char_ptr               ; Set zero page pointer to string address
    STX _char_ptr+1             ; (pointer passed in via the A/X registers)
    LDY #$00
loop:
	LDA (_char_ptr),y
	BEQ newline                    ; Loop until \0
    CALL bios_put_char
	INY
    JMP loop
newline:
    LDA #$0D                    ;  Store CR
    CALL bios_put_char
    LDA #$0A                    ;  Store LF
    CALL bios_put_char
    RTS                         ;  Return
.endproc
 