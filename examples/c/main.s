;
; File generated by cc65 v 2.18 - Git N/A
;
	.fopt		compiler,"cc65 v 2.18 - Git N/A"
	.setcpu		"65C02"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.forceimport	__STARTUP__
	.import		_puts
	.export		_main

.segment	"RODATA"

L0003:
	.byte	$48,$65,$6C,$6C,$6F,$2C,$20,$77,$6F,$72,$6C,$64,$21,$0A,$0A,$0A
	.byte	$00

; ---------------------------------------------------------------
; int __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_main: near

.segment	"CODE"

	lda     #<(L0003)
	ldx     #>(L0003)
	jsr     _puts
	ldx     #$00
	txa
	rts

.endproc

