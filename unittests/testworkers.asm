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
   rts
.endproc

range:
   .byte 80
   .byte 23

.proc worker_decrement_8_test
   prints "worker_decrement_8_test"

   LoadW R15, range
   lda #80
   sta range
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

