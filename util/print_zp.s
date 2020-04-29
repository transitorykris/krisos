; Mike Barry's Print Immediate routine
; http://6502.org/source/io/primm.htm

.ifndef _PRINT_ZP_
_PRINT_ZP_ = 1

    .exportzp primm_lo
    .exportzp primm_hi

; TODO - this can be condensed to a single reservation
primm_lo:   .res 1
primm_hi:   .res 1

.endif