; KrisOS - via_test.s
; Copyright 2020 Kris Foster
;
; Fiddles with the VIA ports on the K64

VIA2_PORTB = $5000
VIA2_PORTA = $5001
VIA2_DDRB = $5002
VIA2_DDRA = $5003

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

ports_on:
    LDA #$FF                    ; Turn all pin output, and on
    STA VIA2_DDRA
    STA VIA2_PORTA
    STA VIA2_DDRB
    STA VIA2_PORTB

done:
    LDA #<done_msg
    STA string_ptr
    LDA #>done_msg
    STA string_ptr+1
    JSR write

    RTS                         ; Return control to KrisOS

test_msg:  .byte   "Turning LED on", CR, LF, NULL
done_msg:  .byte   "Done!", CR, LF, NULL
not_set_msg: .byte "VIA2 did not appear to set correctly",CR,LF,NULL