; getchar.s

    .setcpu "6502"
    .PSC02

    .include "bios.inc"

    .export _getchar

.proc _getchar: near
    CALL bios_get_char
    RTS
.endproc
 