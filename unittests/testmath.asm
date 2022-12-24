.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.include "ut.asm"
.include "math.asm"

.proc main   
   printl str_ut_welcome
   
   jsr test_mul
   jsr test_mad
   jsr test_mul816
   jsr test_mad816
   jsr test_negadd   
   jsr test_lerp

   rts
.endproc


lerp_results:
.byte 7,8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15

.proc test_lerp   
   ldy #0
loop:
   LoadW R12, lerp_results
   lda (R12),y
   tax
   tya
   phy
   jsr test_lerp_inner
   ply
   iny
   cpy #16
   bne loop
   rts
.endproc

; a = factor 0..16
; x = expected result
.proc test_lerp_inner
   pha
   stx R0L
   prints "lerp 7 to 15 for: "
   print_dec
   pla
   ldx #7
   ldy #15
   jsr lerp416
   pha
   prints " = "
   print_dec
   pla 
   cmp R0L
   ut_exp_equal
   rts
.endproc

.proc test_negadd
   LoadW R0, $1000
loop:
   jsr test_negadd_inner
   inc R0L
   dec R0H
   bpl loop
   rts
.endproc

; R0L value for a, R0H expected result
.proc test_negadd_inner
   prints "16-a for a: "
   lda R0L

   pha
   print_dec
   pla

   nad 16

   pha
   prints " = "
   print_dec
   pla

   cmp R0H
   ut_exp_equal
   rts
.endproc

.proc test_mad
   prints "multiply add"

   LoadW R11, $0D0B
   lda #17
   jsr mad88      ; compute 13*11+17 = 160

   cmp #160
   ut_exp_equal

   rts
.endproc

.proc test_mad816
   prints "multiply add (16)"

   LoadW R2, 1235
   LoadW R0, 777
   LoadB R1L, 13
   jsr mad816      ; compute 777*13+1235 = 11336

   lda R2L
   cmp #(11336 & 255)
   bne result
   lda R2H
   cmp #(11336 >> 8)
result:   
   ut_exp_equal

   rts
.endproc


multiply_testcases:
.byte 1,1,1
.byte 2,2,4
.byte 17,3,17*3
.byte 15,15,15*15
.byte 3,16,3*16
.byte 117,2,117*2
.byte 255,0,0
.byte 67,3,67*3
multiply_num_testcases:
.byte (*-multiply_testcases)/3

.proc test_mul
   LoadW R12, multiply_testcases
   ldy #0
   ldx multiply_num_testcases
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
   print_dec R13L
   prints " * "
   print_dec R13H

   ; do the actual multiplication
   MoveB R13L, R11L
   MoveB R13H, R11H
   jsr mul88

   ; print result of multiplication for visual inspection  
   pha
   prints " = "
   print_dec
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

multiply_testcases_816:
.word 1,1,1
.word 2,2,4
.word 255,255,255*255
.word 523,17,523*17
.word 0,16,0
.word 16,0,0
.word 4369,15,4369*15
multiply_num_testcases_816:
.byte (*-multiply_testcases_816)/6


.macro move_word_y Source, Dest
   lda (Source),y
   sta Dest
   iny 
   lda (Source),y
   sta Dest+1
   iny 
.endmacro   
   

.proc test_mul816
   LoadW R12, multiply_testcases_816
   ldy #0
   ldx multiply_num_testcases_816
next_test:   
   phx
   printl msg
   ; load operands and result from tescase table to R0, R1, R2  .. R0*R1 = R2
   move_word_y R12, R0

   phy
   jsr print_dec_16
   prints " * "
   ply

   move_word_y R12, R0   

   phy 
   jsr print_dec_16
   prints " = "
   ply

   move_word_y R12, R0

   phy 
   jsr print_dec_16
   ply

   tya
   sub #6
   tay

   move_word_y R12, R0
   move_word_y R12, R1
   
   ; do the actual multiplication
   phy
   jsr mul816
   ply

   ; do comparison and print unit test result
   lda (R12),y
   tax
   iny
   lda (R12),y
   iny

   cpx R2L
   bne result
   cmp R2H
result:
   phy
   ut_exp_equal
   ply
   plx
   dex
   jne next_test
   rts
msg: lstr "multiply (16) "
.endproc