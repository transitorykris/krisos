; KrisOS Sound Library
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

.ifndef _LIB_SOUND_
_LIB_SOUND_ = 1

    .setcpu "6502"
    .psc02                      ; Enable 65c02 opcodes

    .export sound_init
    .export startup_sound
    .export beep

    .include "sound.inc"
    .include "../io/via.inc"    ; XXX should sound be io?

; Note: currently destructive of other pins on the VIA
sound_init:
    ; Set up our 6522 for the SN76489
    PHA
    LDA #(SN_WE|SN_CE)          ; Ready input, WE and CE output
    STA VIA2_DDRB
    LDA #SN_DATA                ; Default to setting the SN data bus to output
    STA VIA2_DDRA

    ; Initialize the SN76489
    LDA #SN_WE                  ; Set CE low (inactive), WE high (inactive)
    STA VIA2_PORTB
    JSR silence_all             ; Stop it from making noise
    PLA
    RTS

; Register A first byte of note
; Register X second byte of note
play_note:
    ORA #(FIRST|CHANNEL_1|TONE)
    JSR sn_send
    TXA
    ORA #(SECOND|CHANNEL_1|TONE)
    JSR sn_send
    LDA #(FIRST|CHANNEL_1|VOLUME|VOLUME_MAX)
    JSR sn_send
    LDA #(SECOND|CHANNEL_1|VOLUME|VOLUME_MAX)
    JSR sn_send
    RTS

play_note_2:
    ORA #(FIRST|CHANNEL_2|TONE)
    JSR sn_send
    TXA
    ORA #(SECOND|CHANNEL_2|TONE)
    JSR sn_send
    LDA #(FIRST|CHANNEL_2|VOLUME|VOLUME_MAX)
    JSR sn_send
    LDA #(SECOND|CHANNEL_2|VOLUME|VOLUME_MAX)
    JSR sn_send
    RTS

play_note_3:
    ORA #(FIRST|CHANNEL_3|TONE)
    JSR sn_send
    TXA
    ORA #(SECOND|CHANNEL_3|TONE)
    JSR sn_send
    LDA #(FIRST|CHANNEL_3|VOLUME|VOLUME_MAX)
    JSR sn_send
    LDA #(SECOND|CHANNEL_3|VOLUME|VOLUME_MAX)
    JSR sn_send
    RTS

play_note_noise:
    ORA #(FIRST|CHANNEL_NOISE)
    JSR sn_send
    LDA #(FIRST|CHANNEL_NOISE|VOLUME|VOLUME_MAX)
    JSR sn_send
    LDA #(SECOND|CHANNEL_NOISE|VOLUME|VOLUME_MAX)
    JSR sn_send
    RTS

silence_all:
    PHA
    LDA #(FIRST|CHANNEL_1|VOLUME|VOLUME_OFF)
    JSR sn_send
    LDA #(SECOND|%00111111)
    JSR sn_send
    LDA #(FIRST|CHANNEL_2|VOLUME|VOLUME_OFF)
    JSR sn_send
    LDA #(SECOND|%00111111)
    JSR sn_send
    LDA #(FIRST|CHANNEL_3|VOLUME|VOLUME_OFF)
    JSR sn_send
    LDA #(SECOND|%00111111)
    JSR sn_send
    LDA #(FIRST|CHANNEL_NOISE|VOLUME|VOLUME_OFF)
    JSR sn_send
    PLA
    RTS

; A - databus value to strobe SN with
; Note: currently destructive of other pins on the VIA
sn_send:
    PHX
    STA VIA2_PORTA              ; Put our data on the data bus
    LDX #SN_WE                  ; Strobe WE
    STX VIA2_PORTB
    LDX #SN_WE_CLEAR
    STX VIA2_PORTB
    JSR wait_ready              ; Wait for chip to be ready from last instruction
    LDX #SN_WE
    STX VIA2_PORTB
    PLX
    RTS

; Wait for the SN76489 to signal it's ready for more commands
wait_ready:
    PHA
ready_loop:
    LDA VIA2_PORTB
    AND #SN_READY
    BNE ready_loop
ready_done:
    PLA
    RTS

sleep:
    LDX #$00
    LDY #$00
sleep_inner_loop:
    CPX #$FF
    BEQ sleep_outer_loop
    INX
    JMP sleep_inner_loop
sleep_outer_loop:
    LDX #$00
    CPY #$0F
    BEQ sleep_done
    INY
    JMP sleep_inner_loop
sleep_done:
    RTS

startup_sound:
    LDA #Cn5_1
    LDX #Cn5_2
    JSR play_note
    JSR sleep
    LDA #En5_1
    LDX #En5_2
    JSR play_note_2
    JSR sleep
    LDA #Gn5_1
    LDX #Gn5_2
    JSR play_note_3
    JSR sleep
    JSR silence_all
    RTS

beep:
    LDA #Cn5_1
    LDX #Cn5_2
    JSR play_note
    JSR sleep
    JSR silence_all
    RTS

.endif