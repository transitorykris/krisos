; A very hacked up example from
; https://cc65.github.io/doc/customizing.html

    .setcpu "6502"
    .PSC02

    .export _puts
    .exportzp _char_ptr: near

    .zeropage

_char_ptr:  .res 2, $00      ;  Reserve a local zero page pointer

    .segment  "CODE"

.proc _puts: near
    STA _char_ptr               ; Set zero page pointer to string address
    STX _char_ptr+1             ; (pointer passed in via the A/X registers)
    LDY #00                     ; Initialize Y to 0
    LDA (_char_ptr)             ; Load first character

loop:   
	JSR acia_put_char
	INY
	LDA (_char_ptr),y
	BNE loop                    ; Loop until \0
newline:
    LDA #$0D                    ;  Store CR
	JSR acia_put_char
    LDA #$0A                    ;  Store LF
    JSR acia_put_char
    RTS                         ;  Return

acia_put_char:
    PHA                         ; save registers
acia_put_char_loop:
    LDA $4001                   ; serial port STA tus
    AND #$10                    ; is tx buffer empty
    BEQ acia_put_char_loop      ; no, go back and test it again
    PLA                         ; yes, get chr to send
    STA $4000                   ; put character to Port
    RTS
.endproc
