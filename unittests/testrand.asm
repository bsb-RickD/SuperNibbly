.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.ifndef PRINT_ASM
.include "print.asm"
.endif

.ifndef MATH_ASM
.include "math.asm"
.endif

.proc main   
   prints "random generator test."
   newline
   prints "the test will seed the random generator with the current date/time."
   newline
   prints "and will then print 255 numbers"
   newline 2

   jsr rand_seed_time
   
   
   ldx #255
generate:
   phx

   jsr rand8
   pha
   cmp #10
   ble green
   cmp #245
   bge red
white:   
   lda #CHR_COLOR_WHITE
   jsr KRNL_CHROUT
   bra print_it
green:   
   lda #CHR_COLOR_GREEN
   jsr KRNL_CHROUT
   bra print_it
red:   
   lda #CHR_COLOR_RED
   jsr KRNL_CHROUT
print_it: 
   pla
   print_dec
   prints " "

   plx
   dex
   bne generate

   rts
.endproc


