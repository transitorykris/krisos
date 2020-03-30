; KrisOS - crt0.s
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

    .import _main
    .export _init
    .export _exit

    .import __STACKSTART__   ; Linker generated
    .import __STACKSIZE__    ; Linker generated
    .export __STARTUP__ : absolute = 1        ; Mark as startup

    .import copydata
    .import zerobss
    .import initlib
    .import donelib

    .include  "zeropage.inc"

    .segment  "STARTUP"

_init:
    NOP                     ; Nothing to do here.. yet
    LDA #<(__STACKSTART__ + __STACKSIZE__)    ; Argument stack pointers
    STA sp
    LDA #>(__STACKSTART__ + __STACKSIZE__)
    STA sp+1

    JSR zerobss              ; Clear BSS segment
    ;JSR copydata             ; Initialize DATA segment
    JSR initlib              ; Run constructors

    JSR _main           ; Main function from our C program

_exit:
    JSR donelib             ; Run destructors
    RTS                     ; Return control to KrisOS
