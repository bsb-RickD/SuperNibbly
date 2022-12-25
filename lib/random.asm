.ifndef RANDOM_ASM
RANDOM_ASM = 1

.ifndef REGS_INC
.include "regs.inc"
.endif

.ifndef MAC_INC
.include "mac.inc"
.endif

.ifndef KERNAL_INC
.include "kernal.inc"
.endif



; random range objects (16 bit) look like this:
;
; word range start			; offset 0
; byte range length         ; offset 2  


; R0: 	range start
; R1: 	range end
; R15:	points to a 3 byte memory block to initialize the range object
.proc rand_range_init
	ldy #0
	lda R0L
	tax
	sta (R15),y
	iny
	lda R0H
	pha
	sta (R15),y
	iny
	txa
	sub R1L
	sta (R15),y
	iny
	pla
	sbc R1H
	sta (R15),y 
.endproc


.proc rand_range
.endproc




; X ABC Algorithm Random Number Generator for 8-Bit Devices
;
; from https://codebase64.org/doku.php?id=base:x_abc_random_number_generator_8_16_bit
;
; Algorithm from EternityForest, slight modification by Wil
; https://www.electro-tech-online.com/threads/ultra-fast-pseudorandom-number-generator-for-8-bit.124249/
; Implementation and test: Wil
; This version stores the seed as arguments and uses self-modifying code
; Routine requires 38 cycles (without the rts) / 28 bytes
; Return values are in A and, if a 16 bit value is needed also in rand8_highbyte
rand8:
	inc rand_8_x1
	clc
rand_8_x1=*+1
	lda #$00	;x1
rand_8_c1=*+1
	eor #$c2	;c1
rand_8_a1=*+1
	eor #$11	;a1
	sta rand_8_a1
rand_8_b1=*+1
	adc #$37	;b1
	sta rand_8_b1
	lsr
	eor rand_8_a1
	adc rand_8_c1
	sta rand_8_c1
	rts

; use this address if you need a 16 bit random value
rand8_highbyte = rand_8_c1

; seed the random generator from current date/time
;
.proc rand_seed_time
	jsr KRNL_GET_DATE_TIME		; get date and time in R0,R1,R2 and intentionally fall through to rand_seed
.endproc

; seed the random generator
; 
; R1, R2 = seed
; 
.proc rand_seed
	MoveB R1L, rand_8_x1
	MoveB R1H, rand_8_c1
	MoveB R2L, rand_8_a1
	MoveB R2H, rand_8_b1
	rts
.endproc

.endif