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

    .import __USER_START__

TICK = 65335                    ; Who knows how long a second is! This one's fast

user_code_segment = __USER_START__  ; The user's program will be stored here

    .RODATA
init_interrupts_disabled: .byte "Interrupts disabled",CR,LF,NULL
init_via_msg: .byte "Initializing 6521 VIA...",NULL
init_acia_msg: .byte "Initializing 6551 ACIA...",CR,LF,NULL
init_cld_msg: .byte "Disabling BCD mode...",NULL
init_lcd_msg: .byte "Initializing Hitachi LCD....",NULL
init_clear_userspace_msg: .byte "Clearing userspace memory...",NULL
init_reenable_irq_msg: .byte "Re-enabling interrupts...",NULL
init_terminal_msg: .byte "Initializing terminal...",CR,LF,NULL
init_start_cli_msg: .byte "Starting command line...",CR,LF,LF,NULL
init_done_msg: .byte "Done!",CR,LF,NULL
init_default_interrupt_handlers: .byte "Setting default interrupt handlers...",NULL
init_sound_msg: .byte "Initializing Sound...",NULL
init_clock_msg: .byte "Starting the system clock...",NULL

krisos_lcd_message: .byte "KrisOS/K64",NULL

build_time: .dword .time            ; .time is provided by ca65
assembler_version: .word .version   ; .version is provided by ca65

build_time_msg: .byte "Build time ",NULL
assembler_version_msg: .byte "Assembler version ca65 ",NULL
calling_msg: .byte "Starting",CR,LF,LF,NULL
bad_command_msg: .byte "Unknown command, type help for help",CR,LF,NULL
shutdown_msg: .byte "Shutting down...",CR,LF,NULL
uptime_msg: .byte "Uptime: ",NULL
exited_msg: .byte CR,LF,"Exited with code: ",NULL

default_nmi_msg: .byte "Default NMI handler called",CR,LF,NULL
default_irq_msg: .byte "Default IRQ handler called",CR,LF,NULL

.macro case_command command,routine
    .local skip
    CMP command
    BNE skip
    JSR routine
    JMP repl_done
skip:
.endmacro

.endif