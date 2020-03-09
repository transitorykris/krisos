; KrisOS - hello.s
; Copyright 2020 Kris Foster
; A simple Hello, World! that uses the KrisOS kernel

    .include "term.h"

    ;.import ACIA_DATA
    ;.import ACIA_STATUS

ACIA_DATA       = $4000
ACIA_STATUS     = $4001

    .code

hello:
    LDA #<hello_msg
    STA string_ptr
    LDA #>hello_msg
    STA string_ptr+1
    JSR write

write:
    LDY #00
next_char:
wait_txd_empty:
    LDA ACIA_STATUS
    AND #$10
    BEQ wait_txd_empty
    LDA (string_ptr), y
    BEQ write_done
    STA ACIA_DATA
    INY
    JMP next_char
write_done:
    RTS

hello_msg:  .byte   "Hello, World!", CR, LF, NULL