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
    .psc02                      ; Enable 65c02 opcodes

    .fopt author, "Kris Foster <kris.foster@gmail.com>"
    .fopt comment, "Copyright 2020 Kris Foster, MIT Licensed"

    .include "term/term.inc"
    .include "kernel.inc"
    .include "io/lcd.inc"
    .include "term/command.inc"
    .include "io/via.inc"
    .include "util/print.inc"
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
    .import reset_user_input
    .import parse_command
    .import lcd_init
    .import via1_init_ports
    .import via2_init_ports
    .import test_via1
    .import test_via2
    .import lcd_write
    .import binhex
    .import clear_screen
    .import sound_init
    .import startup_sound
    .import beep
    .import dump_stack
    .import bios_get_char
    .import bios_put_char
    .import memtest_user
    .import clear_page
    .import sid_init

    .export return_from_bios_call

    .code
main:
    SEI                         ; Disable interrupts while we initialize
    CLD                         ; Explicitly do not use decimal mode
    LDX #$FF                    ; Initialize our stack pointer
    TXS

    JSR acia_init               ; Set up the serial port
    ; We can't print to the serial port until the above completed
    print "Disabled interrupts"
    print "Disabled BCD mode"
    print "Initialized stack"
    print "Initialized 6551 ACIA"

    print "Initializing terminal...\n\r"
    JSR setup_term              ; Pretty up the user's terminal

init_via1:
    print "Initializing 6522 VIA1..."
    JSR test_via1               ; See if the via works!
    BCS test_via1_failed
    LDA #%11100001              ; LCD signals + 1 pin for LED
    LDX #%11111111              ; LCD databus lines
    print "Done\n\r"
    JMP init_via2
test_via1_failed:
    print "FAILED\n\r"
init_via2:
    print "Initializing 6522 VIA2..."
    JSR test_via2
    BCS test_via2_failed
    JSR via1_init_ports         ; Initialize VIA
    LDA #%00000000
    LDX #%00000000
    JSR via2_init_ports
    print "Done\n\r"
    JMP init_vias_done
test_via2_failed:
    print "FAILED\n\r"
init_vias_done:

.ifdef CFG_SN76489
    print "Initializing SN76489A Sound..."
    JSR sound_init
    JSR startup_sound
    print "Done\n\r"
.endif

.ifdef CFG_SID
    print "Initializing SID Sound..."
    JSR sid_init
    print "Done\n\r"
.endif

.ifdef CFG_LCD
    print "Initializing Hitachi LCD...."
    JSR lcd_init                ; Set up the LCD display
    writeln_lcd krisos_lcd_message
    print "Done\n\r"
.endif

.ifdef CFG_USER_MEMTEST
    print "Testing user space memory..."
    JSR memtest_user
    BCC memory_passed
    print "FAILED\n\r"
    JMP memory_test_done
memory_passed:
    print "Done\n\r"
memory_test_done:
.endif

    print "Clearing userspace memory..."
    LDA #$10                    ; The page to clear
    JSR clear_page
    print "Done\n\r"

    print "Re-enabling interrupts..."
    JSR set_interrupt_handlers
    print "Done\n\r"

    print "Re-enabling interrupts..."
    CLI                         ; Re-enable interrupts
    print "Done\n\r"

    print "Build time "
    write_hex_dword build_time
    print "\n\r"

    print "Assembler version ca65 "
    write_hex_word assembler_version
    print "\n\r"

.ifdef CFG_CLOCK
    ; We start the clock late because it's wired into NMI
    print "Starting the system clock..."
    STZ16 uptime                ; Reset our uptime to zero
    LDA #%01000000              ; T1 continuous interrupts, PB7 disabled
    STA VIA1_ACR
    LDA #%11000000              ; Enable T1 interrupts
    STA VIA1_IER
    LDA #<TICK
    STA VIA1_T1CL               ; Low byte of interval counter
    LDA #>TICK
    STA VIA1_T1CH               ; High byte of interval counter
    print "Done\n\r"
.endif

    print "Starting command line...\n\r"
    print "\nWelcome to KrisOS on the K64\n\n\r"

repl:                           ; Not really a repl but I don't have a better name
    printdbg "Start of CLI\n\r"
    JSR reset_user_input        ; Show a fresh prompt
    writeln prompt              ;
    JSR read                    ; Read command
    JSR parse_command
    ; Switch
    case_command #ERROR_CMD,    error
    case_command #LOAD_CMD,     load_program
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

load_program:
    JSR XModemRcv
    PHA                         ; Save our 16-bit return
    PHX                         ;
    printdbg "\n\rExited with code: "
    PLA                         ; binhex takes the argument in the A register
    JSR binhex
    STA char_ptr
    JSR write_char              ; Display XModem's return value
    print "\n\r"
    JMP repl

run_program:
    .ifdef CFG_DEBUG
        JSR dump_stack
    .endif
    printdbg "Starting\n\n\r"  ; Indicate that we're starting the user's code
    JSR user_code_segment       ; Start it!
    PHA                         ; Save our 16-bit return
    PHX                         ;
    .ifdef CFG_DEBUG
        printdbg "Exited\n\r"
        PLA                     ; binhex takes the argument in the A register
        JSR binhex
        STA char_ptr
        JSR write_char          ; Display the high order byte
        STX char_ptr
        JSR write_char
        PLA
        JSR binhex
        STA char_ptr
        JSR write_char
        STX char_ptr
        JSR write_char          ; Display the low order byte
        printdbg "\n\r"
    .endif
    JSR set_interrupt_handlers  ; Reset our default interrupt handlers
    .ifdef CFG_DEBUG
        JSR dump_stack
    .endif
    printdbg "Interrupt handlers reset\n\r"
    LDX $FF                     ; Reset our stack because cc65 isn't cooperating yet
    TXS
    JMP repl

error:
    print "Unknown command, type help for help\n\r"
    RTS

help:
    writeln help_header_msg
    writeln help_commands_msg
    writeln help_copyright_msg
    RTS

shutdown:
    print "Shutting down...\n\r"
    STP                         ; We do not return from this, ever.

uptime_ticker:
    print "Uptime: "
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
    print "\n\r"
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
    ; You probably don't want to print this if the clock is ticking
    ;printdbg "Default NMI handler called\n\r"
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
    printdbg "Default IRQ handler called\n\r"
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