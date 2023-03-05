.ifndef MATH_DIV_ASM
MATH_DIV_ASM = 1

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

.export div88, div1616

; lerp is not supported for now
;.export lerp416, lerp416_lookup

; 8 bit division, unsigned
; r11H = r11H/r11L, a = remainder
.ifref div88
.proc div88
	div88_ r11H, r11L
	rts
.endproc
.endif

; R0 = R0/R1, R2 = remainder
.ifref div1616 
.proc div1616
	div1616_ R1, R0, R2
	rts
.endproc
.endif

.endif