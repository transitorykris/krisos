    .setcpu "6502"
    .PSC02

bios_write_char = $04

.macro CALL routine
    LDX #routine
    BRK
    NOP
.endmacro