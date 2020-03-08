; KrisOS for the K64
; Copyright 2020 Kris Foster

; 6551 ACIA
ACIA_DATA       = $4000
ACIA_STATUS     = $4001
ACIA_COMMAND    = $4002
ACIA_CONTROL    = $4003

;
; https://www.xfree86.org/current/ctlseqs.html
; https://www.ascii-code.com/
; ASCII constants
ESC     = $1B
LB      = $5B                   ; [
NULL    = $00
CR      = $0d
LF      = $0a                   ; Line feed, aka enter key?

; Pointers
string_ptr = $00

; Macros
.macro writeln  str_addr
    LDA #<str_addr
    STA string_ptr
    LDA #>str_addr
    STA string_ptr+1
    JSR write
.endmacro

    .setcpu "6502"
    .PSC02
    .code

reset:
    ; Set up 6551 ACIA
    LDA #%00001011              ; No parity, no echo, no interrupt
    STA ACIA_COMMAND
    LDA #%00011111              ; 1 stop bit, 8 data bits, 19200 baud
    STA ACIA_CONTROL

    ; White on Blue is the KrisOS color
    writeln x_set_fg_white
    writeln x_set_bg_blue

    ; Write out our welcome message
    writeln x_home_position
    writeln x_erase_display
    writeln x_set_bold
    writeln x_set_underlined
    writeln welcome_msg
    writeln new_line

    ; Reset to a normal font
    writeln x_set_normal
    writeln x_set_not_underlined

    ; Display the command prompt
    writeln prompt

    ; Get some input
    JSR read

halt:
    JMP halt


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

nmi:
    RTI

irq:
    RTI

; Data

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
 
new_line:               .byte CR, LF, NULL
welcome_msg:            .byte "Welcome to KrisOS on the K64", CR, LF, NULL
prompt:                 .byte "OK> ", NULL

    .segment "VECTORS"
    .word nmi
    .word reset
    .word irq