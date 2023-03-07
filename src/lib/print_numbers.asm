.ifndef PRINT_NUMBERS_ASM
PRINT_NUMBERS_ASM = 1

.segment "CODE"

.ifndef COMMON_INC
.include "inc/common.inc"
.endif

.export print_dec_8, print_dec_16, print_hex

; print accumulator as hex
.ifref print_hex
.refto print_hex_digit
.proc print_hex
   pha
   rorn 4
   clc
   jsr print_hex_digit
   pla
   bra print_hex_digit     ; will return to caller
.endproc
.endif

; print accumulator as decimal number
; r11, a, x clobbered
.ifref print_dec_8
.refto print_hex_digit 
.refto print_dec_from_stack_loop 
.import div88
.proc print_dec_8
   cmp #0
   bne not_zero
   clc
   bra print_hex_digit  ; special case - when 0 output single 0 and return (otherwise leading zeros are suppressed)
not_zero:   
   sta r11H
   lda #10
   sta r11L
   ldx #0
divide_loop:
   phx
   jsr div88            ; do divsion
   plx
   pha                  ; a is remainder, remember on stack
   inx                  ; inc number of digits to print
   lda r11H             ; are we done?
   bne divide_loop
.endproc
.endif

; used by both print methods 
;
; x holds the number of digits to print
; stack holds the digits
.ifref print_dec_from_stack_loop
.refto print_hex_digit 
print_dec_from_stack_loop:
   pla
   jsr print_hex_digit
   dex
   bne print_dec_from_stack_loop
   rts
.endif   

; print r0 as decimal number
.ifref print_dec_16
.refto print_dec_from_stack_loop
.import div1616
.proc print_dec_16
   lda R0H
   bne not_zero
   lda R0L
   beq print_dec_8+4  ; special case - print 0 as single 0 (and reuse code from 8-bit print)
not_zero:
   stz R1H
   lda #10
   sta R1L
   ldx #0
divide_loop:
   phx
   jsr div1616
   plx
   lda R2L
   pha
   inx
   lda R0L
   bne divide_loop
   lda R0H
   bne divide_loop
   bra print_dec_from_stack_loop
.endproc   
.endif

; lower nibble of a will be printed as hex
.ifref print_hex_digit
.proc print_hex_digit
   and #$0f
   adc #$30    ; $30 = "0"
   cmp #$3A    ; did we exceed 0..9?
   bcc print_char
   adc #$26    ; bring it to the "A".."F" range
print_char:
   jsr KRNL_CHROUT
   rts
.endproc
.endif


.endif