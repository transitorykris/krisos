; KrisOS - kernel.h
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

.ifndef _KERNEL_H_
_KERNEL_H_ = 1

    .feature string_escapes

    .import __USER_START__

TICK = 65335                    ; Who knows how long a second is! This one's fast

user_code_segment = __USER_START__  ; The user's program will be stored here

    .RODATA
init_interrupts_disabled: .asciiz "Interrupts disable\n\r"
init_via_msg: .asciiz "Initializing 6521 VIA..."
init_acia_msg: .asciiz "Initializing 6551 ACIA..."
init_cld_msg: .asciiz "Disabling BCD mode..."
init_lcd_msg: .asciiz "Initializing Hitachi LCD...."
init_clear_userspace_msg: .asciiz "Clearing userspace memory..."
init_failed_msg: .asciiz "FAILED"
init_reenable_irq_msg: .asciiz "Re-enabling interrupts..."
init_terminal_msg: .asciiz "Initializing terminal...\n\r"
init_start_cli_msg: .asciiz "Starting command line...\n\r"
init_done_msg: .asciiz "Done!\n\r"
init_default_interrupt_handlers: .asciiz "Setting default interrupt handlers..."
init_sound_msg: .asciiz "Initializing SN76489A Sound..."
init_clock_msg: .asciiz "Starting the system clock..."

krisos_lcd_message: .asciiz "KrisOS/K64"

build_time: .dword .time            ; .time is provided by ca65
assembler_version: .word .version   ; .version is provided by ca65

build_time_msg: .asciiz "Build time "
assembler_version_msg: .asciiz "Assembler version ca65 "
calling_msg: .asciiz "Starting\n\n\r"
bad_command_msg: .asciiz "Unknown command, type help for help\n\r"
shutdown_msg: .asciiz "Shutting down...\n\r"
uptime_msg: .asciiz "Uptime: "
exited_msg: .asciiz "\n\rExited with code: "

start_of_repl_msg: .asciiz "start of repl\n\r"
handlers_reset_msg: .asciiz "handlers reset\n\r"

default_nmi_msg: .asciiz "Default NMI handler called\n\r"
default_irq_msg: .asciiz "Default IRQ handler called\n\r"

.macro case_command command,routine
    .local skip
    CMP command
    BNE skip
    JSR routine
    JMP repl_done
skip:
.endmacro

.endif