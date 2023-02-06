.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.ifndef UT_ASM
.include "lib/ut.asm"
.endif

.ifndef ARRAY_ASM
.include "lib/array.asm"
.endif

.ifndef MEMORY_ASM
.include "lib/memory.asm"
.endif


.proc main   
   printl str_ut_welcome

   fill_memory array, 32, 0 
      
   jsr test_array_add
   jsr test_array_add_more
   jsr test_array_remove
   jsr test_array_remove_not_found
   jsr test_array_remove_more
   jsr test_array_remove_even_more
   jsr test_array_append_array
   jsr test_array_append_array_again
   jsr test_array_append_array_empty
   jsr test_array_remove_array
   jsr test_array_remove_array_empty

   rts
.endproc

array:
.res 32, 0


; some helper macros for the unit tests ---------------------------

; append to the array
.macro append p
   lda #p
   jsr array_append
.endmacro

; remove from the array
.macro remove p
   lda #p
   jsr array_remove
.endmacro

; check array content
.macro check_array_content c 
   bra do_comparison
expected:
.byte c
Array_size = *-expected
do_comparison:
   compare_memory array, expected, Array_size
   ut_exp_equal
.endmacro



.proc test_array_add
   prints "array_add"

   LoadW R15, array
   append 0
   append 0
   append 17
   append 2
   append 1

   check_array_content {5, 0,0,17,2,1}

   rts
.endproc 

.proc test_array_add_more
   prints "array_add_more"

   LoadW R15, array
   append 17
   append 18
   append 19
   append 3
   append 3

   check_array_content {10, 0,0,17,2,1,17,18,19,3,3}

   rts
.endproc 

.proc test_array_remove
   prints "array_remove"

   LoadW R15, array
   remove 17
   remove 19
   remove 3

   check_array_content {7, 0,0,2,1,17,18,3}

   rts
.endproc 

.proc test_array_remove_not_found
   prints "array_remove_not_found"

   LoadW R15, array
   remove 25
   remove 99
   remove 33

   check_array_content {7, 0,0,2,1,17,18,3}

   rts
.endproc 

.proc test_array_remove_more
   prints "array_remove_more"

   LoadW R15, array
   remove 3
   remove 0
   remove 17
   remove 0
   remove 1
   remove 18
   remove 2

   check_array_content {0}

   rts
.endproc 

.proc test_array_remove_even_more
   prints "array_remove_even_more"

   LoadW R15, array
   remove 0
   remove 0
   remove 3
   remove 17
   remove 1
   remove 8
   remove 2

  check_array_content {0}

   rts
.endproc 

.proc test_array_append_array
   prints "array_append_array"

   LoadW R15, array
   LoadW R14, array_to_append
   jsr array_append_array

   check_array_content {3, 99,67,55}
   rts

array_to_append:
   .byte 3,99,67,55
.endproc

.proc test_array_append_array_again
   prints "array_append_array_again"

   LoadW R15, array
   LoadW R14, array_to_append
   jsr array_append_array

   check_array_content {7, 99,67,55,109,0,252,29}

   rts
array_to_append:
   .byte 4,109,0,252,29
.endproc

.proc test_array_append_array_empty
   prints "array_append_array_empty"

   LoadW R15, array
   LoadW R14, array_to_append
   jsr array_append_array

   check_array_content {7, 99,67,55,109,0,252,29}

   rts
array_to_append:
   .byte 0,17,18
.endproc

.proc test_array_remove_array
   prints "array_remove_array"

   LoadW R15, array
   LoadW R14, array_to_remove
   jsr array_remove_array
   
   check_array_content {3, 67,109,252}

   rts
array_to_remove:
   .byte 4, 99,55,0,29
.endproc


.proc test_array_remove_array_empty
   prints "array_remove_array_empty"
   
   LoadW R15, array
   LoadW R14, array_to_remove
   jsr array_remove_array
   
   check_array_content {3, 67,109,252}
   rts
array_to_remove:
   .byte 0
.endproc

