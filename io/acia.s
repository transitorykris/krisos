; KrisOS ACIA Library
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

.ifndef _LIB_ACIA_
_LIB_ACIA_ = 1

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "acia.inc"
    .include "../config.inc"

    .import return_from_bios_call

    .export acia_init
    .export acia_get_char
    .export acia_put_char
    .export bios_get_char
    .export bios_put_char

    .segment "LIB"

; Set up 6551 ACIA
acia_init:
    PHA
    LDA #ACIA_HARDWARE_RESET
    STA ACIA_STATUS
    LDA ACIA_DATA               ; Clear errors
    LDA #(ACIA_TX_DIS_RTS_LOW|ACIA_NO_PARITY|ACIA_NO_ECHO|ACIA_IRQ_DISABLE|ACIA_DTR_ENABLE)
    STA ACIA_COMMAND
    LDA #(ACIA_BAUD_GENERATOR|ACIA_1_STOP_BIT|ACIA_8_DATA_BITS|ACIA_19200_BAUD)
    STA ACIA_CONTROL
    PLA
    RTS

bios_put_char:
.ifdef CFG_WDC_ACIA
    PHX
    LDX #$00
bios_delay_loop:
    CPX #$FF
    BEQ bios_delay_loop_done
    INX
    JMP bios_delay_loop
bios_delay_loop_done:
.else
    PHA
wait_txd_empty_char:
    LDA ACIA_STATUS
    AND #$10
    BEQ wait_txd_empty_char
    PLA
.endif
    STA ACIA_DATA
    JMP return_from_bios_call

bios_get_char:
    CLC
    LDA ACIA_STATUS
    AND #$08
    BEQ bios_get_char           ; Block until we get a character
    LDA ACIA_DATA
    SEC
    JMP return_from_bios_call

; From Daryl Rictor's XModem, moved here for re-use.
;
; "Get_Chr" routine will scan the input port for a character.  It will
; return without waiting with the Carry flag CLEAR if no character is
; present or return with the Carry flag SET and the character in the "A"
; register if one was present.
acia_get_char:
    CLC                         ; no chr present
    LDA ACIA_STATUS             ; get Serial port STA tus
    AND #$08                    ; mask rcvr full bit
    BEQ acia_get_char_done      ; if not chr, done
    LDA ACIA_DATA               ; else get chr
    SEC                         ; and set the Carry Flag
acia_get_char_done:
    RTS                         ; done


acia_put_char:
.ifdef CFG_WDC_ACIA
    PHX
    LDX #$00
acia_delay_loop:
    CPX #$FF
    BEQ acia_delay_loop_done
    INX
    JMP acia_delay_loop
acia_delay_loop_done:
.else
    PHA
acia_put_char_loop:
    LDA ACIA_STATUS             ; serial port STA tus
    AND #$10                    ; is tx buffer empty
    BEQ acia_put_char_loop      ; no, go back and test it again
    PLA                         ; yes, get chr to send
.endif
    STA ACIA_DATA               ; put character to Port
    RTS                         ; done

.endif