; KrisOS for the K64
; Copyright 2020 Kris Foster

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "term.h"
    .include "lcd.h"
    .include "command.h"

; External imports
    .import acia_init
    .import XModemRcv
    .import setup_term
    .import read
    .import write
    .import dump
    .import panic
    .import reset_user_input
    .import parse_command
    .import user_input
    .import ACIA_DATA
    .import ACIA_STATUS
    .import lcd_init
    .import via1_init_ports
    .import lcd_write

    .export reset

    .code

user_code_segment = $1000       ; The user's program will be stored here

reset:
    SEI                         ; Disable interrupts while we initialize
    LDX #$FF                    ; Initialize our stack pointer
    TXS
    CLD                         ; Explicitly do not use decimal mode

    JSR acia_init               ; Set up the serial port
    writeln init_acia_msg

    writeln init_terminal_msg
    JSR setup_term              ; Pretty up the user's terminal

    writeln init_via_msg
    LDA #%11100001              ; LCD signals + 1 pin for LED
    LDX #%11111111              ; LCD databus lines
    JSR via1_init_ports         ; Initialize VIA
    writeln init_done_msg    

    writeln init_lcd_msg
    JSR lcd_init                ; Set up the LCD display
    writeln_lcd krisos_lcd_message
    writeln init_done_msg

    writeln init_clear_userspace_msg
    LDA #$00
    LDX #$00
clear_page:                     ; Give the user's code clean space to run in
    STA user_code_segment,X
    CPX #$FF
    BEQ clear_done
    INX
    JMP clear_page
clear_done:
    writeln init_done_msg

    writeln init_reenable_irq_msg
    CLI                         ; Re-enable interrupts
    writeln init_done_msg

    writeln init_start_cli_msg
    writeln welcome_msg

repl:                           ; Not really a repl but I don't have a better name
    ; Show prompt
    JSR reset_user_input

    ; Read command
    writeln prompt
    JSR read

    ; Parse command
    JSR parse_command
    CMP #ERROR_CMD
    BEQ error

    ; Execute command
    CMP #LOAD_CMD
    BEQ load_program
    CMP #RUN_CMD
    BEQ run_program
    CMP #DUMP_CMD
    BEQ dump_program
    CMP #HELP_CMD
    BEQ help
    CMP #SHUTDOWN_CMD
    BEQ shutdown

    JMP repl                    ; Do it all again!

error:
    writeln bad_command_msg
    JMP repl

load_program:
    JSR XModemRcv               ; Retrieve a file using xmodem
    JMP repl

run_program:
    writeln calling_msg         ; Indicate that we're starting the user's code
    JSR user_code_segment       ; Start it!
    JMP repl

dump_program:
    JSR dump
    JMP repl

help:
    writeln LOAD_HELP
    writeln RUN_HELP
    writeln DUMP_HELP
    writeln HELP_HELP
    writeln SHUTDOWN_HELP
    JMP repl

shutdown:
    writeln shutdown_msg
    .byte $DB                   ; STP opcode not in ca65?

nmi:
    RTI

irq:
    RTI

; Kernel messages
init_interrupts_disabled: .byte "Interrupts disabled",CR,LF,NULL
init_via_msg: .byte "Initializing 6521 VIA...",NULL
init_acia_msg: .byte "Initializing 6551 ACIA...",NULL
init_cld_msg: .byte "Disabling BCD mode...",NULL
init_lcd_msg: .byte "Initializing Hitachi LCD....",NULL
init_clear_userspace_msg: .byte "Clearing userspace memory...",NULL
init_reenable_irq_msg: .byte "Re-enabling interrupts...",NULL
init_terminal_msg: .byte "Initializing terminal...",NULL
init_start_cli_msg: .byte "Starting command line...",CR,LF,LF,NULL
init_done_msg: .byte "Done!",CR,LF,NULL

krisos_lcd_message: .byte "KrisOS/K64",NULL

calling_msg: .byte "Starting",CR,LF,LF,NULL
bad_command_msg: .byte "Unknown command, type help for help",CR,LF,NULL
shutdown_msg: .byte "Shutting down...",CR,LF,NULL

    .segment "VECTORS"
    .word nmi
    .word reset
    .word irq