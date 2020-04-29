; From http://6502.org/source/general/clockfreq.htm by Leo Nechaev
; Estimates the clock frequency of the 6502
; Modified for ca65 and K64, Kris Foster 2020

    .setcpu "6502"
    .psc02                      ; Enable 65c02 opcodes

rgConfig    = $6000             ; write: D6=1 - NMI is off, D6=0 - NMI is on
rgStatus    = $6000             ; read: D6=0 - UART is busy
rgTxD       = $5000             ; write: data to send via UART
vcNMI       = $FFFA
Refresh     = 450               ; NMI rate in Hz

    LDX #<NMI                   ; installing the NMI vector
    LDY #>NMI
    STX vcNMI
    STY vcNMI+1
    LDA #$40                    ; on start NMI is off
    STA InUse

Again:
    LDA #0
    STA Flag
    STA Ticks                   ; initializing counter
    STA Ticks+1
    STA Ticks+2
    STA Ticks+3
    LDA #$FE                    ; initializing NMI counter (zeropoint minus 2 ticks)
    STA Timer
    LDA #$FF
    STA Timer+1
    LDA InUse                   ; turn on NMI
    AND #$BF
    STA rgConfig
    STA InUse

:   BIT Flag                    ; waiting for zeropoint minus 1 tick
    BPL :-
    LDA #0
    STA Flag

:   BIT Flag                    ; waiting for true zeropoint
    BPL :-
    LDA #0
    STA Flag

Main:                           ; main counting cycle
                                ;number of ticks per commAND sum of ticks
                                ; v v
    LDA Ticks                   ;4
    CLC                         ;2 6
    SED                         ;2 8
    ADC #$53                    ;2 10
    STA Ticks                   ;4 14
    LDA Ticks+1                 ;4 18
    ADC #0                      ;2 20
    STA Ticks+1                 ;4 24
    LDA Ticks+2                 ;4 28
    ADC #0                      ;2 30
    STA Ticks+2                 ;4 34
    LDA Ticks+3                 ;4 38
    ADC #0                      ;2 40
    STA Ticks+3                 ;4 44
    CLD                         ;2 46
    BIT Flag                    ;4 50
    BPL Main                    ;3 53

    LDA #0                      ;2
    STA Flag                    ;4 6
    LDA Ticks                   ;4 10
    CLC                         ;2 12
    SED                         ;2 14
    ADC #$95                    ;2 16
    STA Ticks                   ;4 20
    LDA Ticks+1                 ;4 24
    ADC #0                      ;2 26
    STA Ticks+1                 ;4 30
    LDA Ticks+2                 ;4 34
    ADC #0                      ;2 36
    STA Ticks+2                 ;4 40
    LDA Ticks+3                 ;4 44
    ADC #0                      ;2 46
    STA Ticks+3                 ;4 50
    CLD                         ;2 52
    LDA Timer                   ;4 56
    CMP #<Refresh               ;2 58
    BNE Main                    ;3 61 + 34 (from NMI ISR) = 95
    LDA Timer+1                 ; 4
    CMP #>Refresh               ; 2
    BNE Main                    ; 3

    LDA InUse                   ; turn off NMI
    ORA #$40
    STA rgConfig
    STA InUse

    LDX #0                      ; send first string to the host
:   LDA Mes1,x
    BEQ :+
    JSR Send
    INX
    JMP :-

:   LDA Ticks+3
    PHA
    LSR
    LSR
    LSR
    LSR
    BEQ :+                      ; delete non-significant zero (clock < 10MHz)
    JSR PrintDigit
:   PLA
    AND #15
    JSR PrintDigit
    LDA #'.'                    ; decimal point
    JSR Send
    LDA Ticks+2
    JSR PrintTwoDigits
    LDA Ticks+1
    JSR PrintTwoDigits
    LDA Ticks
    JSR PrintTwoDigits

    LDX #0                      ; send second string to the host
:   LDA Mes2,x
    BEQ :+
    JSR Send
    INX
    JMP :-
:   JMP Again                   ; repeat process

PrintTwoDigits:
    PHA
    LSR
    LSR
    LSR
    LSR
    JSR PrintDigit
    PLA
    AND #15
    JSR PrintDigit
    RTS

PrintDigit:
    ORA #$30
    JSR Send
    RTS

Send:
    BIT rgStatus
    BVC Send
    STA rgTxD
    RTS

Mes1:
    .byte 13
    .byte "Current clock frequency is "
    .byte 0

Mes2:
    .byte " MHz"
    .byte 0

start_msg: .byte "Start of clock measurement", 0
again_msg: .byte "Again procedure", 0

Ticks:  .byte 4,0
Timer:  .byte 2,0
InUse:  .byte 0
Flag:   .byte 0

NMI:                            ;6
    PHA                         ;3 9
    inc Timer                   ;6 15
    BNE :+                      ;3 18
    inc Timer+1                 ; 5
    : LDA #$80                  ;2 20
    STA Flag                    ;4 24
    PLA                         ;4 28
    RTI                         ;6 34