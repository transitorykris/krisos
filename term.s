; KrisOS Terminal Library
; Copyright 2020 Kris Foster

.ifndef _LIB_TERM_
_LIB_TERM_ = 1

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "term.h"

; External imports
    .import ACIA_DATA
    .import ACIA_STATUS
    .import binhex
    .import write

; Exported symbols
    .export setup_term
    .export read
    .export dump
    .export string_ptr
    .export panic
    .export reset_user_input
    .export user_input
    .export write_char

    .segment "LIB"

setup_term:
    writeln x_set_fg_white          ; White on Blue is the KrisOS color
    writeln x_set_bg_blue           ;

    writeln x_home_position         ; Write out our welcome message
    writeln x_erase_display         ;
    writeln x_set_bold              ;
    writeln x_set_underlined        ;

    writeln x_set_normal            ; Reset to a normal font
    writeln x_set_not_underlined    ;
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
load_and_write:
    LDA $1000,x
    PHX                         ; Save our index on the stack, binhex destroys it
    JSR binhex
    STA $01 ; MSN
    JSR write_char
    STX $01 ; LSN
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

write_char:
    PHA
wait_txd_empty_char:
    LDA ACIA_STATUS
    AND #$10
    BEQ wait_txd_empty_char
    LDA $01
    BEQ write_char_done
    STA ACIA_DATA
write_char_done:
    PLA
    RTS

panic:
    writeln panic_msg
    RTS

reset_user_input:
    PHA
    LDA #<user_input
    STA user_input_ptr
    LDA #>user_input
    STA user_input_ptr+1          ; Point or repoint at our user_input array
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

    .org $0200                  ; temp hack to put this in RAM
; 16 byte placeholder for user input
user_input: .byte NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL

.endif