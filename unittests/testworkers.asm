.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.ifndef UT_ASM
.include "ut.asm"
.endif

.ifndef GENERIC_WORKERS_ASM
.include "generic_workers.asm"
.endif

.proc main      
   printl str_ut_welcome

   jsr worker_decrement_8_test
   jsr worker_decrement_16_test
   jsr worker_initialize_random_range_test
   jsr worker_generate_random_test
   rts
.endproc

range8:
   .byte 80
   .byte 23

.proc worker_decrement_8_test
   prints "worker_decrement_8_test"

   LoadW R15, range8
   lda #80
   sta range8
   ldx #0

again:
   inx
   phx   
   jsr   worker_decrement_8
   plx
   bcc   again
   
   cpx #57
   ut_exp_equal

   rts
.endproc

range16:
   .word 1080
   .word 1023

.proc worker_decrement_16_test
   prints "worker_decrement_16_test"

   LoadW R15, range16
   LoadW range16, 1080
   ldx #0

again:
   inx
   phx   
   jsr   worker_decrement_16
   plx
   bcc   again
   
   cpx #57
   ut_exp_equal

   rts
.endproc


random_range_expect:
.word 230, 130
.byte 255-15


random_range:
.word 130, 360                ; from 130 to 360
.byte 16                      ; chunk: 16
.word random_range_obj        ; store here

random_range_obj:
.res 5,0


.proc worker_initialize_random_range_test
   prints "worker_initialize_random_range_test"

   LoadW R15, random_range
   jsr worker_initialize_random_range

   ut_exp_memory_equal random_range_obj, random_range_expect, 5
   rts
.endproc  

; word points to destination              ; offset 0 - here the random number is stored
; word points to random range object      ; offset 2 - points to the generator, expected to be initialized 
generate_random:
.word generation_dest
.word random_range_obj

generation_not_expect:
.word 0
 

.proc worker_generate_random_test
   prints "worker_generate_random_test"

   LoadW generation_dest, 0            ; init
   
   LoadW R15, generate_random
   jsr worker_generate_random

   ut_exp_memory_neq generation_not_expect, generation_dest, 2
   rts
.endproc   

generation_dest:
.word 0