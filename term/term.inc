; KrisOS term.h
;
; Copyright 2020 Kris Foster
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

.ifndef _TERM_H_
_TERM_H_ = 1

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
x_set_bold:             .byte ESC,"[1m",NULL
x_set_underlined:       .byte ESC,"[4m",NULL
x_set_normal:           .byte ESC,"[22m",NULL
x_set_not_underlined:   .byte ESC,"[24m",NULL
x_set_bg_blue:          .byte ESC,"[44m",NULL
x_set_fg_white:         .byte ESC,"[37m",NULL

; Cursor
x_home_position:        .byte ESC,"[H",NULL
x_left:                 .byte ESC,"[D",NULL
x_backspace:            .byte ESC,"[D",SPACE,ESC,"[D", NULL

; Erasing
x_erase_display:        .byte ESC,"[2J", NULL
x_erase_line:           .byte ESC,"[2K", NULL

; Other
new_line:               .byte CR,LF,NULL
prompt:                 .byte "OK>",SPACE,NULL

; Messages
welcome_msg:    .byte "Welcome to KrisOS on the K64",CR,LF,LF,NULL
panic_msg:      .byte "Something went wrong. BRK called or executed $00?",CR,LF,NULL

; Macros
.macro writeln str_addr
    LDA #<str_addr
    STA string_ptr
    LDA #>str_addr
    STA string_ptr+1
    JSR write
.endmacro

.macro write_hex char_addr
    LDA char_addr
    JSR binhex
    STA char_ptr                ; Most significant number
    JSR write_char
    STX char_ptr                ; Least significant numbers
    JSR write_char
.endmacro

; Assumes little endian
.macro write_hex_word word_addr
    write_hex word_addr+1
    write_hex word_addr
.endmacro

; Assume little endian
.macro write_hex_dword dword_addr
    write_hex dword_addr+3
    write_hex dword_addr+2
    write_hex dword_addr+1
    write_hex dword_addr
.endmacro

.endif