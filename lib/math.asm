.ifndef MATH_ASM
MATH_ASM = 1

.ifndef REGS_INC
.include "inc/regs.inc"
.endif

.ifndef MAC_INC
.include "inc/mac.inc"
.endif

.export mul88, mad88, mul816, mad816, div88, div1616, init_lerp416_table, lerp416, lerp416_lookup

; 8 bit division, unsigned
;
; taken from http://6502org.wikidot.com/software-math-intdiv
;
; calculate: tq = tq/b, a = remainder of tq/b
; TQ, B: unsigned 8 bit numbers
;
.macro div88_ Tq, B
	.local @l1, @l2
   	lda #0
   	ldx #8
   	asl Tq
@l1:
	rol
   	cmp B
   	bcc @l2
   	sbc B
@l2:
	rol Tq
   	dex
   	bne @l1
.endmacro

; 8 bit division, unsigned
; r11H = r11H/r11L, a = remainder
.ifref div88
.proc div88
	div88_ r11H, r11L
	rts
.endproc
.endif

; 16-bit division, 16-bit_result
;
; taken from https://codebase64.org/doku.php?id=base:16bit_division_16-bit_result
;
; divisor = 16 Bit number (in zero page)
; dividend = 16 Bit number (in zero page)
; remainder = 16 Bit number (in zero page)
;
; output:
; dividend = dividend/divisor (saves memory by reusing divident to store the result)
; remainder = remainder 
.macro div1616_ Divisor, Dividend, Remainder
	.local @div_loop, @skip
	stz Remainder		;preset remainder to 0
	stz Remainder+1
	ldx #16	        	;repeat for each bit: ...

@div_loop:
	asl Dividend		;dividend lb & hb*2, msb -> Carry
	rol Dividend+1	
	rol Remainder		;remainder lb & hb * 2 + msb from carry
	rol Remainder+1
	lda Remainder
	sec
	sbc Divisor			;substract divisor to see if it fits in
	tay	        		;lb result -> Y, for we may need it later
	lda Remainder+1
	sbc Divisor+1
	bcc @skip			;if carry=0 then divisor didn't fit in yet

	sta Remainder+1		;else save substraction result as new remainder,
	sty Remainder	
	inc Dividend		;and INCrement result cause divisor fit in 1 times

@skip:
	dex
	bne @div_loop
.endmacro

; R0 = R0/R1, R2 = remainder
.proc div1616
	div1616_ R1, R0, R2
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
.macro mul88_ Num1, Num2
	.local @do_add, @loop, @enter_loop, @end
	lda #$00
	beq @enter_loop
@do_add:
 	clc
 	adc Num1
@loop:
 	asl Num1
@enter_loop: ;For an accumulating multiply (.A = .A + num1*num2), set up num1 and num2, then enter here
 	lsr Num2
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

; 16*8 = 16 multiply
;
; Erik's code - might not be optimal
;
; result += num1 * num2
;
; result needs to be 16 bit            - if not initialized to zero, this becomes multiply add
; num1   also needs to be 16 bit
; num2   is 8 bit
.macro mul816_ Num1, Num2, Result
.local @next, @done, @shift
	ldx #8
	lda Num2
@next:	
	lsr 	
	bcc @shift
	tay
	lda Result
	clc
	adc Num1
	sta Result
	lda Result+1
	adc Num1+1
	sta Result+1
	tya
@shift:	
	beq @done
	asl Num1
	rol Num1+1
	dex
	bne @next
@done:	
.endmacro

; 16*8 bit multiply, 16 bit result
; R2 = R0 * R1L
mul816:
	stz R2L
	stz R2H
	mul816_ R0, R1, R2
	rts

; 16*8 bit multiply, 16 bit result
; R2 = R2 + (R0 * R1L)
mad816 = mul816+4


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

Lerp416_table 	= $400
Asln4_table 	= $500
Rorn4_table 	= $500


.proc init_lerp416_table
	stz R0L
	lda #4
	sta R0H
	ldx #0
outer_loop:	
	ldy #0
inner_loop:	
	lda #4
	stx R11H
	sty R11L
	jsr mad88
	sta (R0)	
	IncW R0
	iny
	cpy #16
	bne inner_loop
	inx
	cpx #16
	bne outer_loop
	ldx #0
	lda #0
	clc
shift_loop:
	sta (R0)	
	adc #16
	IncW R0
	inx
	cpx #16
	bne shift_loop
	lda #$10
	sta R0L
	lda #5
	sta R0H
	ldx #1
ror_loop:	
	txa
	sta (R0)
	inx
	AddVW 16,R0
	cpx #16
	bne ror_loop
	rts
.endproc

; lerp 4 bit numbers from x to y in 16 steps, a holds step 0..16
; result in x : lerp result * 16
;
.proc lerp416_lookup
	beq return_x		; a = 0, return x	
	sta ory+1           ; store it as f for or immediate
	nad 16 				; a = 16-f, clearing carry
	beq return_y        ; if we are zero here, f was 16, so return y
	sta orx+1           ; write f as or immediate
	lda Asln4_table,x   ; a = x*16
orx:	
	ora #00             ; a = x*16+(16-f), ready for the table lookup
	tax	                ; store it in x, for later use
	lda Asln4_table,y 	; a = y*16
ory:	
	ora #00             ; a = y*16+f, ready for table lookup
	tay                 ; remember it in y
	lda Lerp416_table,x ; a = x*(16-f)
	adc Lerp416_table,y ; a = x*(16-f)+y*f

	and #$f0			; mask it
	tax 				; move it to x	 
	rts
return_y:
	lda Asln4_table,y 	; a = y*16
	tax                 ; move to x
	rts	
return_x:
	lda Asln4_table,x 	; a = x*16
	tax                 ; move to x
	rts	
.endproc

.endif