; putchar.s

    .setcpu "6502"
    .PSC02

    .include "bios.inc"

    .export _putchar

.proc _putchar: near
    CALL bios_write_char
    RTS
.endproc
 