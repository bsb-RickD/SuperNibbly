.ifndef MATH_ASM
MATH_ASM = 1

.segment "CODE"

.ifndef REGS_INC
.include "inc/regs.inc"
.endif

.ifndef MAC_INC
.include "inc/mac.inc"
.endif

.ifndef MATH_INC
.include "inc/math.inc"
.endif

.export mul88, mad88, mul816, mad816, div88, div1616
.export init_lerp416_table

; lerp is not supported for now
;.export lerp416, lerp416_lookup

; 8 bit division, unsigned
; r11H = r11H/r11L, a = remainder
.proc div88
	div88_ r11H, r11L
	rts
.endproc

; R0 = R0/R1, R2 = remainder
.proc div1616
	div1616_ R1, R0, R2
	rts
.endproc

; 8 bit multiply
; a = r11H*r11L
mul88:
	mul88_ r11H, r11L
	rts

; 8 bit multiply add
; a = a+r11H*r11L
mad88 = mul88+9


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


/*
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
*/

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

/*
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
*/

.endif