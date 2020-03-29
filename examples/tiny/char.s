; KrisOS - hello.s
; Copyright 2020 Kris Foster
;
; A simple Hello, World! example for KrisOS

LF      = $0a
NULL    = $00
CR      = $0d

; Zero Page pointers
string_ptr = $00

    .include "stdlib.inc"

write_char = $04

.macro CALL bios
    LDX #bios
    BRK
    NOP
.endmacro

    .code

hello:
    LDA #'H'
    CALL write_char

    RTS                         ; Return control to KrisOS
