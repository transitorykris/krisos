; KrisOS Zeropage globals
; Copyright 2020 Kris Foster

.ifndef _LIB_ZEROPAGE_
_LIB_ZEROPAGE_ = 1

    .ZEROPAGE

    .include "term/term_zp.s"
    .include "term/commands_zp.s"
    .include "xmodem/xmodem_zp.s"
    .include "kernel_zp.s"

.endif