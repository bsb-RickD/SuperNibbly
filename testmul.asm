.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.include "lib/ut.asm"
.include "lib/math.asm"

.proc main   
   printl str_ut_welcome
   
   jsr test_mul

   rts
.endproc

testcases:
.byte 1,1,1
.byte 2,2,4
.byte 17,3,17*3
.byte 15,15,15*15
.byte 3,16,3*16
.byte 117,2,117*2
.byte 255,0,0
.byte 67,3,67*3
num_testcases:
.byte (*-testcases)/3


.proc test_mul
   LoadW R12, testcases
   ldy #0
   ldx num_testcases
next_test:   
   phx
   printl msg
   ; load operands and result from tescase table to R13L, R13H, R14L  .. R13L*R13H = R14L
   lda (R12),y
   sta R13L
   iny 
   lda (R12),y
   sta R13H
   iny
   lda (R12),y
   sta R14L
   iny
   phy

   ; print operands
   lda R13L
   jsr print_dec
   prints " * "
   lda R13H
   jsr print_dec

   ; do the actual multiplication
   MoveB R13L, R11L
   MoveB R13H, R11H
   jsr mul88

   ; print result of multiplication for visual inspection  
   pha
   prints " = "
   jsr print_dec
   pla

   ; do comparison and print unit test result
   cmp R14L
   ut_exp_equal

   ply
   plx
   dex
   jne next_test
   rts
msg: lstr "multiply "
.endproc