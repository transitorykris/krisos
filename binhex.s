;
; Adapted from: http://forum.6502.org/viewtopic.php?f=2&t=3164
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

.ifndef _LIB_BINHEX_
_LIB_BINHEX_ = 1

    .export binhex

    .segment "LIB"

binhex:  
    PHA                         ;save byte
    AND #%00001111              ;extract LSN
    TAX                         ;save it
    PLA                         ;recover byte
    LSR                         ;extract...
    LSR                         ;MSN
    LSR
    LSR
    PHA                         ;save MSN
    TXA                         ;LSN
    JSR convert                 ;generate ASCII LSN
    TAX                         ;save
    PLA                         ;get MSN & fall thru
;
;
;   convert nybble to hex ASCII equivalent...
;
convert:
    CMP #$0a
    BCC final                   ;in decimal range
    ;
    ADC #$66                    ;hex compensate
;         
final:
    EOR #%00110000              ;finalize nybble
    RTS                         ;done
;
.endif