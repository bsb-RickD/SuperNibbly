.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.ifndef UT_ASM
.include "lib/ut.asm"
.endif

.ifndef WORK_QUEUE_ASM
.include "lib/work_queue.asm"
.endif

variable_1:
.byte 17

variable_2:
.byte 60

variable_3:
.byte 0

variable_4:
.byte 5

variable_5:
.byte 27



function_ptrs:
   .word 0,0                              ; 0 - nullptr
   no_commands_to_add

   .word increment, variable_1            ; 1 - increment command
   commands_to_add 2,33,34,35

   .word decrement, variable_2            ; 2 - decrement command
   no_commands_to_add

.repeat 30
   .word 0,0                              ; commands 3-32
   no_commands_to_add
.endrepeat

   .word increment, variable_3            ; 33 - increment command
   no_commands_to_add

   .word decrement, variable_4            ; 34 - decrement command
   no_commands_to_add

   .word increment, variable_5            ; 35 - increment command
   no_commands_to_add

; increment, and report done
.proc increment
   lda (R15)
   inc
   sta (R15)
   sec
   rts
.endproc

; decrement, and carry on
.proc decrement
   lda (R15)
   dec
   sta (R15)
   clc
   rts
.endproc

.proc main      
   printl str_ut_welcome

   ; set up for multiple runs
   LoadB variable_1,17
   LoadB variable_2,60
   LoadB variable_3,0
   LoadB variable_4,5
   LoadB variable_5,27

   ; empty queue
   LoadW R15, work_queue
   lda #0
   sta (R15)

   jsr trigger_empty
   jsr trigger_first
   jsr trigger_follow_ups
   jsr trigger_once_more
   rts
.endproc

.proc trigger_empty
   prints "trigger empty queue"

   jsr execute_work_queue                    ; run empty queue

   compare_memory variable_1, expected, 5    ; expect memory unchanged
   ut_exp_equal

   rts
expected:
   .byte 17,60,0,5,27   
.endproc


.proc trigger_first
   prints "trigger first worker"

   LoadW R15, work_queue
   lda #1
   jsr array_append                          ; append first worker to queue - this one should pull the others in

   jsr execute_work_queue                    ; run queue

   compare_memory variable_1, expected, 5    ; expected memory check
   ut_exp_equal

   rts
expected:
   .byte 18,60,0,5,27   
.endproc


.proc trigger_follow_ups
   prints "triggered follow ups?"

   jsr execute_work_queue                    ; run queue

   compare_memory variable_1, expected, 5    ; expected memory check
   ut_exp_equal

   rts
expected:
   .byte 18,59,1,4,28   
.endproc

.proc trigger_once_more
   prints "triggered dec's once more?"

   jsr execute_work_queue                    ; run queue

   compare_memory variable_1, expected, 5    ; expected memory check
   ut_exp_equal

   rts
expected:
   .byte 18,58,1,3,28   
.endproc

