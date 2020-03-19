; KrisOS Zeropage globals for Terminal
; Copyright 2020 Kris Foster

.ifndef _TERM_ZP_
_TERM_ZP_ = 1

    .exportzp string_ptr
    .exportzp user_input_ptr

string_ptr:         .res 2
user_input_ptr:     .res 2           ; Where we can find our raw user input

.endif