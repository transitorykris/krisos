; KrisOS for the K64
;
; Copyright 2020 Kris Foster
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "term/term.inc"
    .include "kernel.inc"
    .include "io/lcd.inc"
    .include "term/command.inc"
    .include "io/via.inc"
    .include "util/toolbox.inc"
    .include "config.inc"

    .importzp nmi_ptr
    .importzp irq_ptr
    .importzp string_ptr
    .importzp char_ptr
    .importzp uptime

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
    .import via2_init_ports
    .import lcd_write
    .import binhex
    .import clear_screen
    .import sound_init
    .import startup_sound
    .import beep
    .import dump_stack
    .import bios_get_char
    .import bios_put_char

    .export return_from_bios_call

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
    LDA #%01100000
    LDA #%11111111
    JSR via2_init_ports
    writeln init_done_msg

.ifdef CFG_SN76489
    writeln init_sound_msg
    JSR sound_init
    JSR startup_sound
    writeln init_done_msg
.endif

.ifdef CFG_LCD
    writeln init_lcd_msg
    JSR lcd_init                ; Set up the LCD display
    writeln_lcd krisos_lcd_message
    writeln init_done_msg
.endif

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

.ifdef CFG_CLOCK
    ; We start the clock late because it's wired into NMI
    writeln init_clock_msg
    STZ16 uptime                ; Reset our uptime to zero
    LDA #%01000000              ; T1 continuous interrupts, PB7 disabled
    STA VIA1_ACR
    LDA #%11000000              ; Enable T1 interrupts
    STA VIA1_IER
    LDA #<TICK
    STA VIA1_T1CL               ; Low byte of interval counter
    LDA #>TICK
    STA VIA1_T1CH               ; High byte of interval counter
    writeln init_done_msg
.endif

    writeln init_start_cli_msg
    writeln welcome_msg

repl:                           ; Not really a repl but I don't have a better name
    write_debug start_of_repl_msg
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
    case_command #BEEP_CMD,     beep
    case_command #UPTIME_CMD,   uptime_ticker
    case_command #STACK_CMD,    dump_stack
repl_done:
    JMP repl                    ; Do it all again!

start_of_repl_msg: .byte "start of repl",CR,LF,NULL

run_program:
    .ifdef CFG_DEBUG
        JSR dump_stack
    .endif
    writeln calling_msg         ; Indicate that we're starting the user's code
    JSR user_code_segment       ; Start it!
    PHA                         ; Save our 16-bit return
    PHX                         ;
    writeln exited_msg
    PLA                         ; binhex takes the argument in the A register
    JSR binhex
    STA char_ptr
    JSR write_char              ; Display the high order byte
    STX char_ptr
    JSR write_char
    PLA
    JSR binhex
    STA char_ptr
    JSR write_char
    STX char_ptr
    JSR write_char              ; Display the low order byte
    writeln new_line
    JSR set_interrupt_handlers  ; Reset our default interrupt handlers
    write_debug handlers_reset_msg
    .ifdef CFG_DEBUG
        JSR dump_stack
    .endif
    LDX $FF                     ; Reset our stack because cc65 isn't cooperating yet
    TXS
    JMP repl

handlers_reset_msg: .byte "handlers reset",CR,LF,NULL

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

uptime_ticker:
    writeln uptime_msg
    LDA uptime+1                ; High order byte of uptime
    JSR binhex
    STA char_ptr
    JSR write_char
    STX char_ptr
    JSR write_char
    LDA uptime                  ; Low order byte of uptime
    JSR binhex
    STA char_ptr
    JSR write_char
    STX char_ptr
    JSR write_char
    writeln new_line
    RTS

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
    PHA
    PHX
    PHY
uptime_handler:
    BIT VIA1_T1CL               ; Clear interrupt
    INC16 uptime
    JMP (nmi_ptr)               ; Call the user's NMI handler
default_nmi:                    ; Do nothing
    PLY
    PLX
    PLA
    RTI

irq:
    ; TODO check if it's a BRK, that's a BIOS call
    ; Otherwise use the default handler
    JMP (irq_ptr)

default_irq:
    JMP (bios_jmp_table,X)
return_from_bios_call:
    ;writeln default_irq_msg
    RTI

bios_jmp_table:
    .word $0000
    .word $0000
    .word bios_put_char
    .word bios_get_char

    .segment "VECTORS"
    .word nmi
    .word main
    .word irq