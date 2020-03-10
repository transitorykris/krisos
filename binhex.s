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
.endif