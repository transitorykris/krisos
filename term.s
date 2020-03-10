; KrisOS Terminal Library
; Copyright 2020 Kris Foster

.ifndef _LIB_TERM_
_LIB_TERM_ = 1

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "term.h"

; External imports
    .import ACIA_DATA
    .import ACIA_STATUS
    .import binhex

; Exported symbols
    .export setup_term
    .export read
    .export write
    .export string_ptr
    .export panic

    .segment "LIB"

setup_term:
    writeln x_set_fg_white          ; White on Blue is the KrisOS color
    writeln x_set_bg_blue           ;

    writeln x_home_position         ; Write out our welcome message
    writeln x_erase_display         ;
    writeln x_set_bold              ;
    writeln x_set_underlined        ;
    writeln welcome_msg             ;
    writeln new_line                ;

    writeln x_set_normal            ; Reset to a normal font
    writeln x_set_not_underlined    ;
    RTS

; Code below has been cribbed from
; https://www.grappendorf.net/projects/6502-home-computer/acia-serial-interface-hello-world.html

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

dump:
    LDX #$FF
dump_loop:
    INX
    CPX #$FF
    BEQ dump_done
    LDA $1000,x
    PHX
    JSR binhex
    STA $01 ; MSN
    JSR write_char
    STX $01 ; LSN
    JSR write_char
    PLX
    JMP dump_loop
dump_done:

write_char:
wait_txd_empty_char:
    LDA ACIA_STATUS
    AND #$10
    BEQ wait_txd_empty_char
    LDA $01
    BEQ write_char_done
    STA ACIA_DATA
write_char_done:
    RTS

panic:
    writeln panic_msg
    RTS



.endif