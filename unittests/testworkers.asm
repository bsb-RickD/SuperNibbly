.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.ifndef UT_ASM
.include "lib/ut.asm"
.endif

.ifndef GENERIC_WORKERS_ASM
.include "lib/generic_workers.asm"
.endif

.ifndef MEMORY_ASM
.include "lib/memory.asm"
.endif


.proc main      
   printl str_ut_welcome

   jsr worker_decrement_8_test
   jsr worker_decrement_16_test
   jsr worker_initialize_random_range_test
   jsr worker_generate_random_test
   jsr worker_sequence_test
   jsr worker_parallel_test
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

seq_range8:
.byte 80
.byte 77

seq_random_range:
.word 150, 250                ; from 150 to 250
.byte 0                       ; chunk: all
.word seq_random_range_obj    ; store here

seq_random_range_obj:
.res 5,0

; word points to destination              ; offset 0 - here the random number is stored
; word points to random range object      ; offset 2 - points to the generator, expected to be initialized 
seq_generate_random:
.word seq_generation_dest
.word seq_random_range_obj

seq_generation_dest:
.word 0

seq_worker:
   make_sequence                                                 \
      worker_decrement_8, seq_range8,                            \
      worker_initialize_random_range, seq_random_range,          \
      worker_generate_random, seq_generate_random

.proc worker_sequence_test
   prints "worker_sequence_test"

   LoadB seq_range8, 80                ; init
   LoadW seq_generation_dest, 0        ; init
   
   LoadW R15, seq_worker   
   jsr worker_sequence
   bcs too_early_termination
   lda seq_range8
   cmp #79
   jne decrement_error

   LoadW R15, seq_worker   
   jsr worker_sequence
   bcs too_early_termination
   lda seq_range8
   cmp #78
   jne decrement_error

   LoadW R15, seq_worker
   jsr worker_sequence
   bcs too_early_termination
   lda seq_range8
   cmp #77
   jne decrement_error

   ; random range init
   LoadW R15, seq_worker
   jsr worker_sequence
   jcs too_early_termination

   ; random range output
   LoadW R15, seq_worker
   jsr worker_sequence
   jcc too_late_termination
   lda seq_generation_dest
   jeq no_random_generated
   
   ut_pass
   rts
.endproc 

too_early_termination:
   ut_fail
   prints " (expected more steps)", CHR_NL
   rts
decrement_error:
   ut_fail
   prints " (decrement value mismatch)", CHR_NL
   rts
too_late_termination:
   ut_fail
   prints " (expected sequence end)", CHR_NL
   rts
no_random_generated:
   ut_fail
   prints " (expected random number)", CHR_NL
   rts   


par_range8_1:
.byte 150
.byte 147

par_range8_2:
.byte 16
.byte 10


par_random_range:
.word 150, 250                ; from 150 to 250
.byte 0                       ; chunk: all
.word par_random_range_obj    ; store here

par_random_range_obj:
.res 5,0

empty:
.res 5,0

par_worker:
   make_parallel                                                 \
      worker_decrement_8, par_range8_1,                          \
      worker_initialize_random_range, par_random_range,          \
      worker_decrement_8, par_range8_2

.proc worker_parallel_test
   prints "worker_parallel_test"

   LoadB par_range8_1, 150                ; init
   LoadB par_range8_2, 16                 ; init
   fill_memory par_random_range_obj,5,0   ; init
   LoadW R15, par_worker
   jsr worker_parallel_reset              ; init

   LoadW R15, par_worker
   jsr worker_parallel
   jcs too_early_termination
   lda par_range8_1
   cmp #149
   jne decrement_error
   lda par_range8_2
   cmp #15
   jne decrement_error
   compare_memory empty, par_random_range_obj, 5
   jeq no_random_generator_init

   LoadW R15, par_worker
   jsr worker_parallel
   jcs too_early_termination
   lda par_range8_1
   cmp #148
   jne decrement_error
   lda par_range8_2
   cmp #14
   jne decrement_error

   LoadW R15, par_worker
   jsr worker_parallel
   jcs too_early_termination
   lda par_range8_1
   cmp #147
   jne decrement_error
   lda par_range8_2
   cmp #13
   jne decrement_error

   LoadW R15, par_worker
   jsr worker_parallel
   jcs too_early_termination
   lda par_range8_1
   cmp #147
   jne decrement_too_far_error
   lda par_range8_2
   cmp #12
   jne decrement_error

   LoadW R15, par_worker
   jsr worker_parallel
   jcs too_early_termination
   lda par_range8_1
   cmp #147
   jne decrement_too_far_error
   lda par_range8_2
   cmp #11
   jne decrement_error

   LoadW R15, par_worker
   jsr worker_parallel
   jcc too_late_termination
   lda par_range8_1
   cmp #147
   jne decrement_too_far_error
   lda par_range8_2
   cmp #10
   jne decrement_error

   ut_pass
   rts
decrement_too_far_error:
   ut_fail
   prints " (expected decr to stop)", CHR_NL
no_random_generator_init:
   ut_fail
   prints " (expected random initialization)", CHR_NL
   rts   
.endproc  