; KrisOS - hello.s
; Copyright 2020 Kris Foster
;
; Dump all the ASCII characters

LF      = $0a
NULL    = $00
CR      = $0d

; Zero Page pointers
string_ptr = $00

    .include "stdlib.inc"

    .code

main:
    LDA #<char
    STA string_ptr
    LDA #>char
    STA string_ptr+1
loop:
    LDA char
    CMP #$FF
    BEQ done
    JSR write
    INC char
    JMP loop
done:
    RTS                         ; Return control to KrisOS

char:  .byte   $00, NULL