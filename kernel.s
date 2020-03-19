; KrisOS for the K64
; Copyright 2020 Kris Foster

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "term.inc"
    .include "kernel.inc"
    .include "lcd.inc"
    .include "command.inc"

    .importzp nmi_ptr
    .importzp irq_ptr
    .importzp string_ptr
    .importzp char_ptr

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
    CLD                         ; Explicitly do not use decimal mode
    LDX #$FF                    ; Initialize our stack pointer
    TXS

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

    writeln init_default_interrupt_handlers
    JSR set_interrupt_handlers
    writeln init_done_msg
    writeln init_reenable_irq_msg
    CLI                         ; Re-enable interrupts
    writeln init_done_msg

    writeln build_time_msg
    write_hex_dword build_time
    writeln new_line

    writeln assembler_version_msg
    write_hex_word assembler_version
    writeln new_line

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
    case_command #BREAK_CMD,    soft_irq
repl_done:
    JMP repl                    ; Do it all again!

run_program:
    writeln calling_msg         ; Indicate that we're starting the user's code
    JSR user_code_segment       ; Start it!
    JSR set_interrupt_handlers  ; Reset our default interrupt handlers
    RTS

error:
    writeln bad_command_msg
    RTS

help:
    writeln help_header_msg
    writeln help_commands_msg
    ;writeln help_copyright_msg
    RTS

shutdown:
    writeln shutdown_msg
    STP
    ; We do not return from this, ever.

soft_irq:
    BRK
    .byte $00                   ; RTI sends us to second byte after BRK
    RTS

set_interrupt_handlers:
    LDA #<default_nmi
    STA nmi_ptr
    LDA #>default_nmi
    STA nmi_ptr+1
    LDA #<default_irq
    STA irq_ptr
    LDA #>default_irq
    STA irq_ptr+1
    RTS

nmi:
    JMP (nmi_ptr)

default_nmi:
    writeln default_nmi_msg
    RTI

irq:
    JMP (irq_ptr)

default_irq:
    writeln default_irq_msg
    RTI

    .segment "VECTORS"
    .word nmi
    .word main
    .word irq