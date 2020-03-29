; KrisOS Standard Library
; Copyright 2020 Kris Foster

.ifndef _LIB_STD_
_LIB_STD_ = 1

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "term.inc"
    .include "acia.inc"

    .importzp string_ptr

    .export write

    ;.org $d000                  ; Location of the write subroutine
    .segment "STDLIB"

write:
    PHY
    LDY #00
next_char:
wait_txd_empty:
    LDA ACIA_STATUS
    AND #$10
    BEQ wait_txd_empty
    LDA (string_ptr), y
    BEQ write_done
    STA ACIA_DATA
    CPY #$FF                    ; Are we crossing a page boundary?
    BEQ cross_page
    INY                         ; Nope, increment index
    JMP next_char
cross_page:
    INC string_ptr+1            ; Move to the next page
    LDY #$00                    ; Reset our index
    JMP next_char
write_done:
    PLY
    RTS

.endif