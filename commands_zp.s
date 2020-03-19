; KrisOS Zeropage globals for Commands
; Copyright 2020 Kris Foster

.ifndef _COMMANDS_ZP_
_COMMANDS_ZP_ = 1

    .exportzp strcmp_first_ptr
    .exportzp strcmp_second_ptr

strcmp_first_ptr:   .res 2
strcmp_second_ptr:  .res 2

.endif