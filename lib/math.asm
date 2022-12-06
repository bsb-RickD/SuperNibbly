.ifndef div88

.include "../inc/regs.inc"
.include "../inc/mac.inc"


; 8 bit division, unsigned
;
; taken from http://6502org.wikidot.com/software-math-intdiv
;
; calculate: tq = tq/b, a = remainder of tq/b
; TQ, B: unsigned 8 bit numbers
;
.macro div88_ tq, b
	.local @l1, @l2
   	lda #0
   	ldx #8
   	asl tq
@l1:
	rol
   	cmp b
   	bcc @l2
   	sbc b
@l2:
	rol tq
   	dex
   	bne @l1
.endmacro

; 8 bit division, unsigned
; r11H = r11H/r11L, a = remainder
.proc div88
	div88_ r11H, r11L
	rts
.endproc

; General 8bit * 8bit = 8bit multiply
; by White Flame 20030207
;
; taken from https://codebase64.org/doku.php?id=base:8bit_multiplication_8bit_product
;
; Multiplies "num1" by "num2" and returns result in .A
; Instead of using a bit counter, this routine early-exits when num2 reaches zero, thus saving iterations.
;
;
; Input variables:
;   num1 (multiplicand)
;   num2 (multiplier), should be small for speed
;   Signedness should not matter
;
; .X and .Y are preserved
; num1 and num2 get clobbered
.macro mul88_ num1, num2
	.local @do_add, @loop, @enter_loop, @end
	lda #$00
	beq @enter_loop
@do_add:
 	clc
 	adc num1
@loop:
 	asl num1
@enter_loop: ;For an accumulating multiply (.A = .A + num1*num2), set up num1 and num2, then enter here
 	lsr num2
 	bcs @do_add
 	bne @loop
@end:
.endmacro

; 8 bit multiply
; a = r11H*r11L
.proc mul88
	mul88_ r11H, r11L
	rts
.endproc

.endif