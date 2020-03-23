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

    .code

hello:
    LDA #<hello_msg
    STA string_ptr
    LDA #>hello_msg
    STA string_ptr+1
    JSR write

    RTS                         ; Return control to KrisOS

hello_msg:  .byte   "Hello, World!", CR, LF, NULL