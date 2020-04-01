; KrisOS - Simple sound example
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
    .PSC02

    .include "stdlib.inc"

.macro writeln  str_addr
    LDA #<str_addr
    STA string_ptr
    LDA #>str_addr
    STA string_ptr+1
    JSR write
.endmacro

string_ptr = $00

; SN76489A
FIRST           = %10000000
SECOND          = %00000000
CHANNEL_1       = %00000000
CHANNEL_2       = %00100000
CHANNEL_3       = %01000000
CHANNEL_NOISE   = %01100000
TONE            = %00000000
VOLUME          = %00010000
VOLUME_OFF      = %00001111
VOLUME_MAX      = %00000000

; Some notes
C5_BYTE_1       = $07
C5_BYTE_2       = $07
D5_BYTE_1       = $0a
D5_BYTE_2       = $06
E5_BYTE_1       = $0E
E5_BYTE_2       = $05
G5_BYTE_1       = $0F
G5_BYTE_2       = $04

; 6522 VIA
PORTB = $5000
PORTA = $5001
DDRB  = $5002
DDRA  = $5003

; SN76489AN
SN_READY        = %10000000     ; Ready pin
SN_WE           = %01000000     ; Write enable pin (active low)
SN_CE           = %00100000     ; Chip enable pin (active low) - Tied to ground

CR      = $0D   ; Carriage Return
LF      = $0A   ; Line Feed
NULL    = $00   ; Null char

    .code

reset:
    writeln init_msg

    LDA #(SN_WE|SN_CE)      ; CE and WE pins to output, READY to input
    STA DDRA
    LDA #%11111111          ; Default to setting the SN data bus to output
    STA DDRB

    ; Initialize the SN76489
    LDA #(SN_WE|SN_CE)      ; Set CE low (inactive), WE high (inactive)
    STA PORTA
    writeln done_msg

    writeln silence_msg
    JSR silence_all
    JSR sleep
    JSR sleep
    writeln done_msg

    ;RTS

    writeln done_msg

    ; Play Mary Had a Little Lamb located
    writeln start_msg
    LDX #$00                ; Index into our song array
play_song:
    INX
    LDA song,X              ; Load the first byte of the note
    INX
    LDY song,X              ; Load the second byte of the note
    JSR play_note
    CPX song                ; Have we played all the notes?
    BEQ song_done
    JMP play_song
song_done:
    writeln end_msg
    RTS

; Register A first byte of note
; Register Y second byte of note
play_note:
    ORA #(FIRST|CHANNEL_1|TONE)
    JSR sn_send
    TYA
    ORA #(SECOND|CHANNEL_1|TONE)
    JSR sn_send
    LDA #(FIRST|CHANNEL_1|VOLUME|VOLUME_MAX)
    JSR sn_send
    LDA #(SECOND|CHANNEL_1|VOLUME|VOLUME_MAX)
    JSR sn_send
    JSR sleep
    JSR silence_all
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
sn_send:
    PHX
    STA PORTB               ; Put our data on the data bus
    LDX #%01000000          ; Strobe WE
    STX PORTA
    LDX #%00000000          
    STX PORTA
    JSR wait_ready          ; Wait for chip to be ready from last instruction
    LDX #%01000000
    STX PORTA
    PLX
    RTS

; Wait for the SN76489 to signal it's ready for more commands
wait_ready:
    PHA
ready_loop:
    LDA PORTA
    AND #SN_READY
    BNE ready_loop
ready_done:
    PLA
    RTS

sleep:
    PHX
    PHY
    LDY #$00
    LDX #$00
sleep2:
    CPX #$FF
    BEQ sleep2b
    INX
    JMP sleep2
sleep2b:
    CPY #$FF
    BEQ sleep_done
    INY
    LDX #$00
    JMP sleep2
sleep_done:
    PLY
    PLX
    RTS

    ; Song: first verse of Mary had a Little Lamb
song:
    .byte $34                 ; 26 notes in this array
    .byte E5_BYTE_1,E5_BYTE_2 ; M
    .byte D5_BYTE_1,D5_BYTE_2 ; ry
    .byte C5_BYTE_1,C5_BYTE_2 ; had
    .byte D5_BYTE_1,D5_BYTE_2 ; a
    .byte E5_BYTE_1,E5_BYTE_2 ; lit-
    .byte E5_BYTE_1,E5_BYTE_2 ; tle
    .byte E5_BYTE_1,E5_BYTE_2 ; lamb
    .byte D5_BYTE_1,D5_BYTE_2 ; lit-
    .byte D5_BYTE_1,D5_BYTE_2 ; tle
    .byte D5_BYTE_1,D5_BYTE_2 ; lamb
    .byte E5_BYTE_1,E5_BYTE_2 ; lit-
    .byte G5_BYTE_1,G5_BYTE_2 ; tle
    .byte G5_BYTE_1,G5_BYTE_2 ; lab
    .byte E5_BYTE_1,E5_BYTE_2 ; Ma
    .byte D5_BYTE_1,D5_BYTE_2 ; ry
    .byte C5_BYTE_1,C5_BYTE_2 ; had
    .byte D5_BYTE_1,D5_BYTE_2 ; a
    .byte E5_BYTE_1,E5_BYTE_2 ; lit-
    .byte E5_BYTE_1,E5_BYTE_2 ; tle
    .byte E5_BYTE_1,E5_BYTE_2 ; lamb
    .byte E5_BYTE_1,E5_BYTE_2 ; its
    .byte D5_BYTE_1,D5_BYTE_2 ; fleece
    .byte D5_BYTE_1,D5_BYTE_2 ; was
    .byte E5_BYTE_1,E5_BYTE_2 ; white
    .byte D5_BYTE_1,D5_BYTE_2 ; as
    .byte C5_BYTE_1,C5_BYTE_2 ; snow

init_msg: .byte "Initializing SN76489A",CR,LF,NULL
done_msg: .byte "Done",CR,LF,NULL
start_msg: .byte "Playin song", CR,LF,NULL
end_msg: .byte "Finished playing",CR,LF,NULL
silence_msg: .byte "Silencing",CR,LF,NULL
