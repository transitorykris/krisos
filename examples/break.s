; KrisOS - break.s
; Copyright 2020 Kris Foster
;
; Demonstrates how to create user definable IRQs

    .include "stdlib.h"

.macro writeln str_addr
    LDA #<str_addr
    STA string_ptr
    LDA #>str_addr
    STA string_ptr+1
    JSR write
.endmacro

LF      = $0a
NULL    = $00
CR      = $0d

string_ptr = $00

    .code

main:
    LDA #<irq_handler
    STA irq_ptr
    LDA #>irq_handler
    STA irq_ptr+1               ; Set the location of our IRQ handler

    writeln brk_msg
    BRK
    .byte $00                   ; Padding required for proper return address
    writeln returned_msg
    RTS                         ; Return control to KrisOS

irq_handler:
    writeln handler_msg
    RTI

brk_msg:        .byte "Generating a BRK",CR,LF,NULL
handler_msg:    .byte "Inside of the IRQ handler",CR,LF,NULL
returned_msg:   .byte "Returned from IRQ",CR,LF,NULL
