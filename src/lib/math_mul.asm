.ifndef MATH_MUL_ASM
MATH_MUL_ASM = 1

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

.export mul88, mad88, mul816, mad816

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

.endif