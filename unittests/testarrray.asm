.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.include "common.inc"
.include "ut.asm"
.include "array.asm"

.proc main   
   printl str_ut_welcome

   fill_memory array, 32, 0 
      
   jsr test_array_add
   jsr test_array_add_more
   jsr test_array_remove
   jsr test_array_remove_not_found
   jsr test_array_remove_more
   jsr test_array_remove_even_more

   rts
.endproc

array:
.res 32, 0

expected_after_add:
.byte 5,0,0,17,2,1

expected_after_add_more:
.byte 10,0,0,17,2,1,17,18,19,3,3

expected_after_remove:
.byte 7,0,0,2,1,17,18,3


.proc test_array_add
   prints "array_add"

   LoadW R15, array
   lda #0
   jsr array_append
   lda #0
   jsr array_append
   lda #17
   jsr array_append
   lda #2
   jsr array_append
   lda #1
   jsr array_append

   compare_memory array, expected_after_add, 6
   ut_exp_equal

   rts
.endproc 

.proc test_array_add_more
   prints "array_add_more"

   LoadW R15, array
   lda #17
   jsr array_append
   lda #18
   jsr array_append
   lda #19
   jsr array_append
   lda #3
   jsr array_append
   lda #3
   jsr array_append

   compare_memory array, expected_after_add_more, 11
   ut_exp_equal

   rts
.endproc 

.proc test_array_remove
   prints "array_remove"

   LoadW R15, array
   lda #17
   jsr array_remove
   lda #19
   jsr array_remove
   lda #3
   jsr array_remove

   compare_memory array, expected_after_remove, 8
   ut_exp_equal

   rts
.endproc 

.proc test_array_remove_not_found
   prints "array_remove_not_found"

   LoadW R15, array
   lda #25
   jsr array_remove
   lda #99
   jsr array_remove
   lda #33
   jsr array_remove

   compare_memory array, expected_after_remove, 8
   ut_exp_equal

   rts
.endproc 

.proc test_array_remove_more
   prints "array_remove_more"

   LoadW R15, array
   lda #3
   jsr array_remove
   lda #0
   jsr array_remove
   lda #17
   jsr array_remove
   lda #0
   jsr array_remove
   lda #1
   jsr array_remove
   lda #18
   jsr array_remove
   lda #2
   jsr array_remove


   lda (R15)
   ut_exp_equal

   rts
.endproc 

.proc test_array_remove_even_more
   prints "array_remove_even_more"

   LoadW R15, array
   lda #0
   jsr array_remove
   lda #0
   jsr array_remove
   lda #3
   jsr array_remove
   lda #17
   jsr array_remove
   lda #1
   jsr array_remove
   lda #8
   jsr array_remove
   lda #2
   jsr array_remove


   lda (R15)
   ut_exp_equal

   rts
.endproc 
