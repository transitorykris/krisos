; A very hacked up example from
; https://cc65.github.io/doc/customizing.html

    .setcpu "6502"
    .PSC02

    .include "bios.inc"

    .export _puts
    .exportzp _char_ptr: near

    .zeropage

_char_ptr:  .res 2, $00      ;  Reserve a local zero page pointer

    .segment  "CODE"

.proc _puts: near
    STA _char_ptr               ; Set zero page pointer to string address
    STX _char_ptr+1             ; (pointer passed in via the A/X registers)
    LDY #$00
loop:
	LDA (_char_ptr),y
	BEQ newline                    ; Loop until \0
    CALL bios_put_char
	INY
    JMP loop
newline:
    LDA #$0D                    ;  Store CR
    CALL bios_put_char
    LDA #$0A                    ;  Store LF
    CALL bios_put_char
    RTS                         ;  Return
.endproc
 