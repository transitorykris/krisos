; KrisOS ACIA Library
; Copyright 2020 Kris Foster

.ifndef _LIB_ACIA_
_LIB_ACIA_ = 1

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "acia.h"

    .export acia_init
    .export acia_get_char
    .export acia_put_char

    .segment "LIB"

; Set up 6551 ACIA
acia_init:
    PHA
    LDA #ACIA_HARDWARE_RESET
    STA ACIA_STATUS
    LDA ACIA_DATA               ; Clear errors
    LDA #(ACIA_TX_DIS_RTS_LOW|ACIA_NO_PARITY|ACIA_NO_ECHO|ACIA_IRQ_DISABLE|ACIA_DTR_ENABLE)
    ;LDA #%00001011              ; No parity, no echo, no interrupt
    STA ACIA_COMMAND
    LDA #(ACIA_BAUD_GENERATOR|ACIA_1_STOP_BIT|ACIA_8_DATA_BITS|ACIA_19200_BAUD)
    LDA #%00011111              ; 1 stop bit, 8 data bits, 19200 baud
    STA ACIA_CONTROL
    PLA
    RTS

; From Daryl Rictor's XModem, moved here for re-use.
;
; "Get_Chr" routine will scan the input port for a character.  It will
; return without waiting with the Carry flag CLEAR if no character is
; present or return with the Carry flag SET and the character in the "A"
; register if one was present.
acia_get_char:
    CLC   ; no chr present
    LDA ACIA_STATUS             ; get Serial port STA tus
    AND #$08                    ; mask rcvr full bit
    BEQ acia_get_char_done      ; if not chr, done
    LDA ACIA_DATA               ; else get chr
    SEC                         ; and set the Carry Flag
acia_get_char_done:
    RTS                         ; done


acia_put_char:
    PHA                         ; save registers
acia_put_char_loop:
    LDA ACIA_STATUS             ; serial port STA tus
    AND #$10                    ; is tx buffer empty
    BEQ acia_put_char_loop      ; no, go back and test it again
    PLA                         ; yes, get chr to send
    STA ACIA_DATA               ; put character to Port
    RTS                         ; done

.endif