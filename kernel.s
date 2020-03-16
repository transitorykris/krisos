; KrisOS for the K64
; Copyright 2020 Kris Foster

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "kernel.h"
    .include "term.h"
    .include "lcd.h"
    .include "command.h"

; External imports
    .import acia_init
    .import XModemRcv
    .import setup_term
    .import read
    .import write
    .import write_char
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
    .import binhex              ; For build time and ca65 version
    .import clear_screen

    .code
main:
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

    ;writeln build_time_msg
    JSR write_build_time
    JSR write_assembler_version
    ;writeln assembler_version_msg

    writeln init_start_cli_msg
    writeln welcome_msg

repl:                           ; Not really a repl but I don't have a better name
    JSR reset_user_input        ; Show a fresh prompt
    writeln prompt              ;
    JSR read                    ; Read command
    JSR parse_command
    ; Switch
    case_command #ERROR_CMD,    error
    case_command #LOAD_CMD,     XModemRcv
    case_command #RUN_CMD,      run_program
    case_command #DUMP_CMD,     dump
    case_command #HELP_CMD,     help
    case_command #SHUTDOWN_CMD, shutdown
    case_command #CLEAR_CMD,    clear_screen
    case_command #RESET_CMD,    main
repl_done:
    JMP repl                    ; Do it all again!

run_program:
    writeln calling_msg         ; Indicate that we're starting the user's code
    JSR user_code_segment       ; Start it!
    RTS

error:
    writeln bad_command_msg
    RTS

help:
    writeln help_header_msg
    writeln help_commands_msg
    writeln help_copyright_msg
    RTS

shutdown:
    writeln shutdown_msg
    STP
    ; We do not return from this, ever.

nmi:
    RTI

irq:
    RTI

write_build_time:
    writeln build_time_msg
    write_hex build_time+3
    write_hex build_time+2
    write_hex build_time+1
    write_hex build_time
    writeln new_line
    RTS

write_assembler_version:
    writeln assembler_version_msg
    write_hex assembler_version+1
    write_hex assembler_version
    writeln new_line
    RTS

    .segment "VECTORS"
    .word nmi
    .word main
    .word irq