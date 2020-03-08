; KrisOS for the K64
; Copyright 2020 Kris Foster

    .include "term.s"

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes
    .code

reset:
    JSR acia_init

    ; White on Blue is the KrisOS color
    writeln x_set_fg_white
    writeln x_set_bg_blue

    ; Write out our welcome message
    writeln x_home_position
    writeln x_erase_display
    writeln x_set_bold
    writeln x_set_underlined
    writeln welcome_msg
    writeln new_line

    ; Reset to a normal font
    writeln x_set_normal
    writeln x_set_not_underlined

    ; Display the command prompt
    writeln prompt

    ; Get some input
    JSR read

halt:
    JMP halt

nmi:
    RTI

irq:
    RTI

; Data
welcome_msg:            .byte "Welcome to KrisOS on the K64", CR, LF, NULL

    .segment "VECTORS"
    .word nmi
    .word reset
    .word irq