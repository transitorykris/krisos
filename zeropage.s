; KrisOS Zeropage globals
; Copyright 2020 Kris Foster

.ifndef _LIB_ZEROPAGE_
_LIB_ZEROPAGE_ = 1

    .exportzp string_ptr

; Zero Page pointers
    .ZEROPAGE
string_ptr: .res 2

.endif