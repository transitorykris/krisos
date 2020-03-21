; KrisOS - via_test.s
; Copyright 2020 Kris Foster
;
; Fiddles with the VIA ports on the K64

VIA2_PORTA = 5000
VIA2_DDRA = 5001


LF      = $0a
NULL    = $00
CR      = $0d

; Zero Page pointers
string_ptr = $00

    .include "stdlib.inc"

    .code

hello:
    LDA #<test_msg
    STA string_ptr
    LDA #>test_msg
    STA string_ptr+1
    JSR write

    LDA #$FF
    STA VIA2_DDRA
    STA VIA2_PORTA

    RTS                         ; Return control to KrisOS

test_msg:  .byte   "Turning LED on", CR, LF, NULL