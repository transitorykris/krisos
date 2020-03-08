; KrisOS Terminal Library
; Copyright 2020 Kris Foster

    .include "acia.s"
    
    .segment "LIB"

; https://www.xfree86.org/current/ctlseqs.html
; https://www.ascii-code.com/
; ASCII constant

ESC     = $1B
LB      = $5B                   ; [
NULL    = $00
CR      = $0d
LF      = $0a                   ; Line feed, aka enter key?

; xterm control sequences
x_set_bold:             .byte ESC, LB, '1', 'm', NULL
x_set_underlined:       .byte ESC, LB, '4', 'm', NULL
x_set_normal:           .byte ESC, LB, '2', '2', 'm', NULL
x_set_not_underlined:   .byte ESC, LB, '2', '4', 'm', NULL
x_set_bg_blue:          .byte ESC, LB, '4', '4', 'm', NULL
x_set_fg_white:         .byte ESC, LB, '3', '7', 'm', NULL

; Cursor
x_home_position:        .byte ESC, LB, 'H', NULL

; Erasing
x_erase_display:        .byte ESC, LB, '2', 'J', NULL
x_erase_line:           .byte ESC, LB, '2', 'K', NULL

; Other
new_line:               .byte CR, LF, NULL
prompt:                 .byte "OK> ", NULL

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
    RTS                         ; I don't believe we ever hit this
write_line_feed:                ; XXX: this is desctructive of string_ptr!
    writeln new_line
    writeln prompt
    JMP read