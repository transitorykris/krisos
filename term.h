; KrisOS term.h
; Copyright 2020 Kris Foster

.ifndef _TERM_H_
_TERM_H_ = 1

;
; ASCII codes
; https://www.ascii-code.com/
;
ESC     = $1B
LB      = $5B                   ; [
NULL    = $00
CR      = $0d
LF      = $0a                   ; Line feed, aka enter key?

;
; xterm control sequences
; https://www.xfree86.org/current/ctlseqs.html
;
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

.endif