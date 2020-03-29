    .setcpu "6502"
    .PSC02

bios_put_char = $04
bios_get_char = $06

.macro CALL routine
    LDX #routine
    BRK
    NOP
.endmacro