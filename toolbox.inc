; KrisOS Toolbox Library
; Copyright 2020 Kris Foster
; A collection of handy macros

; Zero out 16-bit memory location
.macro STZ16 addr
    STZ addr
    STZ addr+1
.endmacro

; Increment a 16-bit value in memory
.macro INC16 addr
.scope
    PHX                         ; Safety over speed and size
    LDX addr
    INX
    STX addr
    CPX $FF
    BNE done
    STZ addr
    INC addr+1
done:
    PLX
.endscope
.endmacro
