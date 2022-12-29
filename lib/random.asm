.ifndef RANDOM_ASM
RANDOM_ASM = 1

.ifndef REGS_INC
.include "inc/regs.inc"
.endif

.ifndef MAC_INC
.include "inc/mac.inc"
.endif

.ifndef KERNAL_INC
.include "inc/kernal.inc"
.endif



; random range objects (16 bit) look like this:
;
; word range length			; offset 0  
; word range start			; offset 2
; byte chunksize			; offset 3 - should be a power of 2 (or 0 for all) 


; R0: 	range start
; R1: 	range end
; R2L:  chunksize
;
; R15:	points to a 5 byte memory block to initialize the range object
;
; notes - the random range must not exceed 255
.proc rand_range_init
	ldy #0
	; subtract R0 from R1
	lda R1L
	sec
	sbc R0L
	sta (R15),y 		; store result low
	iny
	lda R1H
	sbc R0H
	sta (R15),y 		; store result high
	iny

	; now copy start over
	lda R0L
	sta (R15),y
	iny
	lda R0H
	sta (R15),y
	iny	

	; copy chunk size over (-1 so it becomes a mask)
	lda R2L
	dec
	eor #$FF
	sta (R15),y

	rts	
.endproc


; get next random number in the range
; the retunred value will b in the range [start, end) 
; so the values go from start to end-1
;
; R15: "this pointer" to random range object
;
; returns: R0 - the next random number in that range
.proc rand_range
	jsr rand8 				; get random number in a
	sta R1L             	; store as scaler

	ThisLoadW R15, R0, 0,-  ; load range length into R0
	jsr mul816              ; multiply

	ldy	#4
	lda (R15),y 			; get chunk size
	and R2H                 ; apply it to R2H (into a)


	; R2H is now the offset we want to add to the start
	ldy #2
	clc
	adc (R15),y
	iny
	sta R0L
	lda (R15),y
	adc #0
	sta R0H					; R0 now holds the result

	rts
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