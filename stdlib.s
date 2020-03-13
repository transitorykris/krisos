; KrisOS Standard Library
; Copyright 2020 Kris Foster

.ifndef _LIB_STD_
_LIB_STD_ = 1

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "term.h"

    .import ACIA_DATA
    .import ACIA_STATUS

    .export write

    .segment "STDLIB"           ; This is the segment

    .org $d000                  ; Location of the write subroutine
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

.endif