; KrisOS for the K64
; Copyright 2020 Kris Foster

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "term.h"

; External imports
    .import acia_init
    .import XModemRcv
    .import setup_term
    .import read
    .import write
    .import panic
    .import ACIA_DATA
    .import ACIA_STATUS

    .code

reset:
    JSR acia_init
    JSR setup_term

    LDA #$00
    LDX #$00
clear_page:
    STA $1000,X
    CPX #$FF
    BEQ clear_done
    INX
    JMP clear_page
clear_done:

    JSR XModemRcv

dump:
    LDX #$FF
dump_loop:
    INX
    CPX #$FF
    BEQ dump_done
    LDA $1000,x
    PHX
    JSR binhex
    STA $01 ; MSN
    JSR write_char
    STX $01 ; LSN
    JSR write_char
    PLX
    JMP dump_loop
dump_done:
    LDA #<calling_msg
    STA $00
    LDA #>calling_msg
    STA $01  
    JSR write ; things seem to work up until here

start_user_program:
    JSR $1000

get_next_command:
    JSR read

calling_msg: .byte "Starting",CR,LF,LF,LF,NULL

halt:
    JMP halt

write_char:
next_char:
wait_txd_empty:
    LDA ACIA_STATUS
    AND #$10
    BEQ wait_txd_empty
    LDA $01
    BEQ write_done
    STA ACIA_DATA
write_done:
    RTS

;
;binhex: CONVERT BINARY BYTE TO HEX ASCII CHARS
;
;   ————————————————————————————————————
;   Preparatory Ops: .A: byte to convert
;
;   Returned Values: .A: MSN ASCII char
;                    .X: LSN ASCII char
;                    .Y: entry value
;   ————————————————————————————————————
;
binhex:  
         pha                   ;save byte
         and #%00001111        ;extract LSN
         tax                   ;save it
         pla                   ;recover byte
         lsr                   ;extract...
         lsr                   ;MSN
         lsr
         lsr
         pha                   ;save MSN
         txa                   ;LSN
         jsr convert           ;generate ASCII LSN
         tax                   ;save
         pla                   ;get MSN & fall thru
;
;
;   convert nybble to hex ASCII equivalent...
;
convert: cmp #$0a
         bcc final          ;in decimal range
;
         adc #$66           ;hex compensate
;         
final:   eor #%00110000     ;finalize nybble
         rts                ;done
;

nmi:
    RTI

irq:
    ;JSR panic
    ;JSR halt
    RTI

    .segment "VECTORS"
    .word nmi
    .word reset
    .word irq