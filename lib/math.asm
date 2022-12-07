.ifndef div88

.include "regs.inc"
.include "mac.inc"


; 8 bit negate + add
;
; a = value - a
;
; so to negate a, use "nad 0"
.macro nad value
	eor #$FF
	sec
	adc #value
.endmacro


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
mul88:
	mul88_ r11H, r11L
	rts

; 8 bit multiply add
; a = a+r11H*r11L
mad88 = mul88+9

; lerp 4 bit numbers from x to y in 16 steps, a holds step 0..16
; result in a
;
; clobbers R11 and R12L
.proc lerp416
	; the original lerp factor from a will be called f in the comments below
	pha
	nad 16
	sta R11H
	stx R11L
	jsr mul88
	sta	R12L		; R12L = (16-f)*x
	sty R11L
	pla
	sta R11H 
	jsr mul88       ; a = f*y
	add R12L        ; a = (16-f)*x+f*y
	adc #8          ; add rounding
	rorn 4
	and #$0f 
	rts
.endproc

.endif