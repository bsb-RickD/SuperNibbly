.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.ifndef PRINT_ASM
.include "print.asm"
.endif

.ifndef RANDOM_ASM
.include "random.asm"
.endif

.proc main      
   jsr rand_test
   jsr rand_range_test

   rts
.endproc

.proc rand_test
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
   
   newline 2
   rts
.endproc

range_obj:
.word 0,0

.proc rand_range_test
   prints "random generator test."
   newline
   prints "now 100 random numbers in the range 240 to 277"
   newline 2

   ; initialize range
   LoadW R15, range_obj
   LoadW R0,240
   LoadW R1,277
   jsr rand_range_init
   
   ldx #100
generate:
   phx

   ; get next number in range
   jsr rand_range

   ; print result
   CmpWI R0,240
   ble green
   CmpWI R0,276
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
   jsr print_dec_16
   prints " "

   plx
   dex
   bne generate
   
   newline 2
   rts
.endproc

