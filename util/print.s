; Mike Barry's Print Immediate routine
; http://6502.org/source/io/primm.htm
;
; Note
; - this is untested
; - this version works on WDC 6502s only

.ifndef _LIB_PRIMM_
_LIB_PRIMM_ = 1

    .setcpu "6502"
    .psc02                      ; Enable 65c02 opcodes

    .import acia_put_char

    .export primm

primm:
    PLA                         ; get low part of (string address-1)
    STA primm_lo
    PLA                         ; get high part of (string address-1)
    STA primm_hi
    BRA primm3
primm2:
    JSR acia_put_char           ; output a string char
primm3:
    INC primm_lo                ; advance the string pointer
    BNE primm4
    INC primm_hi
primm4:
    LDA (primm_lo)              ; get string char
    BNE primm2                  ; output and continue if not NUL
    LDA primm_hi
    PHA
    LDA primm_lo
    PHA
    RTS                         ; proceed at code following the NUL

.endif