; KrisOS Sound Library
; Copyright 2020 Kris Foster

.ifndef _LIB_SOUND_
_LIB_SOUND_ = 1

sound_init:
    ; Set up our 6522 for the SN76489
    LDA #%10000110          ; CE and WE pins to output, READY to input
    STA VIA2_DDRB
    LDA #%11111111          ; Default to setting the SN data bus to output
    STA VIA2_DDRA

    ; Initialize the SN76489
    LDA #%10000110          ; Set CE low (inactive), WE high (inactive)
    STA VIA2_PORTB
    JSR silence_all         ; Stop it from making noise
    
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
sn_send:
    PHX
    STA PORTA               ; Put our data on the data bus
    LDX #%00000010          ; Strobe WE
    STX PORTB
    LDX #%00000000          
    STX PORTB
    JSR wait_ready          ; Wait for chip to be ready from last instruction
    LDX #%00000010
    STX PORTB
    PLX
    RTS

; Wait for the SN76489 to signal it's ready for more commands
wait_ready:
    PHA
ready_loop:
    LDA PORTB
    AND #SN_READY
    BNE ready_loop
ready_done:
    PLA
    RTS

.endif