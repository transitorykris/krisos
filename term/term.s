; KrisOS Terminal Library
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

.ifndef _LIB_TERM_
_LIB_TERM_ = 1

    .setcpu "6502"
    .psc02                      ; Enable 65c02 opcodes

    .include "term.inc"
    .include "../io/acia.inc"   ; XXX more structural smell?

    .importzp string_ptr
    .importzp user_input_ptr
    .importzp char_ptr

    .import binhex
    .import write

    .export setup_term
    .export read
    .export dump
    .export reset_user_input
    .export user_input
    .export write_char
    .export clear_screen
    .export dump_stack

    .segment "RAM"

; 16 byte placeholder for user input
user_input: .res 16, NULL

    .segment "LIB"

setup_term:
    JSR clear_screen
    RTS

; Code below has been cribbed from
; https://www.grappendorf.net/projects/6502-home-computer/acia-serial-interface-hello-world.html

read:
    PHA
    PHY
    LDA #<user_input
    STA user_input_ptr          ; Lo address
    LDA #>user_input
    STA user_input_ptr+1        ; Hi address
    LDY #$00                    ; Counter used for tracking where we are in buffer
read_next:
    LDA ACIA_STATUS
    AND #$08
    BEQ read_next
    LDA ACIA_DATA
enter_pressed:
    CMP #CR                     ; User pressed enter?
    BEQ read_done               ; Yes, don't save the CR
is_backspace:
    CMP #BS
    BNE echo_char               ; Nope
    CPY #$00                    ; Already at the start of the buffer?
    BEQ read_next               ; Yep
    writeln x_backspace         ; left, space, left to delete the character
    DEY                         ; Back up a position in our buffer, need to check for $00
    LDA #NULL
    STA (user_input_ptr),y      ; Delete the character in our buffer
    JMP read_next               ; Get the next character
echo_char:
    STA ACIA_DATA               ; Otherwise, echo the char
save_char:
    STA (user_input_ptr),y      ; And save it
    CPY #$0e                    ; Our 16 char buffer full? (incl null)
    BEQ read_done               ; Yes, get out of here
    INY                         ; Otherwise, move to the next position in the buffer
    JMP read_next               ; And read the next key
read_done:
    INY                         ; Add a NULL in the next position
    LDA #NULL
    STA (user_input_ptr),y       ; Make sure the last char is null
    writeln new_line
    PLY
    PLA
    RTS

dump:
    PHA
    PHX
    LDX #$00
dump_loop:
prefix_new_lines:
    TXA
    AND #$0F                    ; Note, this destroys the A register
    BNE load_and_write
    TXA
    PHX                         ; write_char destroys the X register
    JSR binhex
    STA char_ptr                ; MSN
    JSR write_char
    STX char_ptr                ; LSN
    JSR write_char
    PLX    
    LDA #':'
    STA char_ptr
    JSR write_char
    LDA #SPACE
    STA char_ptr
    JSR write_char
load_and_write:
    LDA $1000,x
    PHX                         ; Save our index on the stack, binhex destroys it
    JSR binhex
    STA char_ptr                ; MSN
    JSR write_char
    STX char_ptr                ; LSN
    JSR write_char
    LDA #SPACE
    STA char_ptr
    JSR write_char
    PLX                         ; Get our index back
check_new_line:
    TXA
    AND #$0F
    CMP #$0F
    BNE dump_next
    writeln new_line            ; This also covers a new_line at the end of the page
check_end_of_page:
    CPX #$FF
    BEQ dump_done
dump_next:
    INX
    JMP dump_loop
dump_done:
    PLX
    PLA
    RTS

dump_stack:
    PHA
    PHX
    LDX #$00
dump_loop_stack:
prefix_new_lines_stack:
    TXA
    AND #$0F                    ; Note, this destroys the A register
    BNE load_and_write_stack
    TXA
    PHX                         ; write_char destroys the X register
    JSR binhex
    STA char_ptr                ; MSN
    JSR write_char
    STX char_ptr                ; LSN
    JSR write_char
    PLX
    LDA #':'
    STA char_ptr
    JSR write_char
    LDA #SPACE
    STA char_ptr
    JSR write_char
load_and_write_stack:
    LDA $0100,x
    PHX                         ; Save our index on the stack, binhex destroys it
    JSR binhex
    STA char_ptr                ; MSN
    JSR write_char
    STX char_ptr                ; LSN
    JSR write_char
    LDA #SPACE
    STA char_ptr
    JSR write_char
    PLX                         ; Get our index back
check_new_line_stack:
    TXA
    AND #$0F
    CMP #$0F
    BNE dump_next_stack
    writeln new_line            ; This also covers a new_line at the end of the page
check_end_of_page_stack:
    CPX #$FF
    BEQ dump_done_stack
dump_next_stack:
    INX
    JMP dump_loop_stack
dump_done_stack:
    PLX
    PLA
    RTS

write_char:
    PHA
wait_txd_empty_char:
    LDA ACIA_STATUS
    AND #$10
    BEQ wait_txd_empty_char
    LDA char_ptr
    BEQ write_char_done
    STA ACIA_DATA
write_char_done:
    PLA
    RTS

reset_user_input:
    PHA
    LDA #<user_input
    STA user_input_ptr
    LDA #>user_input
    STA user_input_ptr+1        ; Point or repoint at our user_input array
    LDY #$00
clear_user_input_loop:
    LDA #NULL
    STA (user_input_ptr), y     ; Zero it out
    CPY #$0f                    ; 16 bytes in user_input
    BEQ reset_user_input_done
    INY
    JMP clear_user_input_loop
reset_user_input_done:
    PLA
    RTS

clear_screen:
    writeln x_set_fg_white      ; White on Blue is the KrisOS color
    writeln x_set_bg_blue
    writeln x_home_position
    writeln x_erase_display
    writeln x_set_normal        ; Reset to a normal font
    writeln x_set_not_underlined 
    RTS

.endif