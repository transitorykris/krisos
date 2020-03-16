; KrisOS term.h
; Copyright 2020 Kris Foster

.ifndef _TERM_H_
_TERM_H_ = 1

; Zero Page pointers
string_ptr = $00                ; Any routine may write to this
user_input_ptr = $02            ; Where we can find our raw user input
strcmp_first_ptr = $F0
strcmp_second_ptr = $F2

; Non-visible ASCII codes
; https://www.ascii-code.com/
;
NULL    = $00   ; Null char
SOH     = $01   ; Start of Heading
STXT    = $02   ; Start of Text (STX is a valid opcode)
ETX     = $03   ; End of Text
EOT     = $04   ; End of Transmission
ENQ     = $05   ; Enquiry
ACK     = $06   ; Acknowledgement
BEL     = $07   ; Bell
;BS     = $08   ; Backspace, see DEL
HT      = $09   ; Horizontal Tab
LF      = $0A   ; Line Feed
VT      = $0B   ; Vertical Tab
FF      = $0C   ; Form Feed
CR      = $0D   ; Carriage Return
SO      = $0E   ; Shift Out / x-on
SI      = $0F   ; Shift In / X-off
DLE     = $10   ; Data Line Escape
DC1     = $11   ; Device Control 1 (often XON)
DC2     = $12   ; Device Control 2
DC3     = $13   ; Device Control 3 (often XOFF)
DC4     = $14   ; Device Control 4
NAK     = $15   ; Negative Acknowledgement
SYN     = $16   ; Synchronous Idle
ETB     = $17   ; End of Transmit Block
CAN     = $18   ; Cancel
EM      = $19   ; End of Medium
SUB     = $1A   ; Substitute
ESC     = $1B   ; Escape
FS      = $1C   ; File Separator
GS      = $1D   ; Group Separator
RS      = $1E   ; Record Separator
US      = $1F   ; Unit Separator
SPACE   = $20   ; Space
DEL     = $7F   ; Delete
BS      = $7F   ; Backspace on Mac

    .RODATA
;
; xterm control sequences
; https://www.xfree86.org/current/ctlseqs.html
;
x_set_bold:             .byte ESC, '[', '1', 'm', NULL
x_set_underlined:       .byte ESC, '[', '4', 'm', NULL
x_set_normal:           .byte ESC, '[', '2', '2', 'm', NULL
x_set_not_underlined:   .byte ESC, '[', '2', '4', 'm', NULL
x_set_bg_blue:          .byte ESC, '[', '4', '4', 'm', NULL
x_set_fg_white:         .byte ESC, '[', '3', '7', 'm', NULL

; Cursor
x_home_position:        .byte ESC, '[', 'H', NULL
x_left:                 .byte ESC, '[', 'D', NULL
x_backspace:            .byte ESC, '[', 'D', ' ', ESC, '[', 'D', NULL

; Erasing
x_erase_display:        .byte ESC, '[', '2', 'J', NULL
x_erase_line:           .byte ESC, '[', '2', 'K', NULL

; Other
new_line:               .byte CR, LF, NULL
prompt:                 .byte "OK> ", NULL

; Messages
welcome_msg:    .byte "Welcome to KrisOS on the K64", CR, LF, LF, NULL
panic_msg:      .byte "Something went wrong. BRK called or executed $00?", CR, LF, NULL

; Macros
.macro writeln  str_addr
    LDA #<str_addr
    STA string_ptr
    LDA #>str_addr
    STA string_ptr+1
    JSR write
.endmacro

.endif