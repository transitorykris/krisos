; KrisOS Terminal Library
; Copyright 2020 Kris Foster

.ifndef _LIB_TERM_
_LIB_TERM_ = 1

    .include "term.h"

; External imports
    .import ACIA_DATA
    .import ACIA_STATUS

; Exported symbols
    .export read

; Zero Page pointers
string_ptr = $00

; Macros
.macro writeln  str_addr
    LDA #<str_addr
    STA string_ptr
    LDA #>str_addr
    STA string_ptr+1
    JSR write
.endmacro

    .segment "LIB"

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

read:
    LDA ACIA_STATUS
    AND #$08
    BEQ read
    LDX ACIA_DATA
    JSR write_acia
    JMP read

write_acia:
    STX ACIA_DATA
    CPX #CR
    BEQ write_line_feed
    JMP read
write_line_feed:
    writeln new_line
    writeln prompt
    JMP read

.endif