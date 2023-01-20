.ifndef WORK_QUEUE_ASM
WORK_QUEUE_ASM = 1

.ifndef COMMON_INC
.include "inc/common.inc"
.endif

.ifndef ARRAY_ASM
.include "lib/array.asm"
.endif

.macro commands_to_add base, p1, p2, p3, p4
.local OFFSET
OFFSET = ((base-function_ptrs)/8)
.if .paramcount = 0
   .byte 0,0,0,0
.elseif .paramcount = 1
   .error "you need to specify a base ptr"
.elseif .paramcount = 2
   .byte OFFSET+p1,0,0,0
.elseif .paramcount = 3
   .byte OFFSET+p1,OFFSET+p2,0,0
.elseif .paramcount = 4
   .byte OFFSET+p1,OFFSET+p2,OFFSET+p3,0
.elseif .paramcount = 5
   .byte OFFSET+p1,OFFSET+p2,OFFSET+p3,OFFSET+p4
.endif
.if (.paramcount > 1) .and (base < $80D)
   .error "base ptr is very suspicious - did you forget to specify one?"
.endif   
.endmacro 

.define no_commands_to_add commands_to_add

work_queue:
   .res 64,0

workers_to_add:
   .res 16,0

workers_to_remove:
   .res 16,0      

; execte the work queue - call this from the main loop
.proc execute_work_queue
   lda work_queue                ; worker count
   beq work_loop_empty
   ldx #1
fetch_next_worker:
   pha                           ; push the number of workers to call
   phx                           ; save worker index

   lda work_queue,x              ; get next function number
   sta remove_this_fnum+1        ; remember it, in case we need to remove it on completion
   stz R0H                       ; multiply a by 8 into R0
.repeat 3   
   asl
   rol R0H
.endrepeat                       ; R0H = high byte, a = low byte of func ptr * 8, carry is clear 
   adc #<function_ptrs
   sta R0L
   lda R0H
   adc #>function_ptrs 
   sta R0H                       ; R0 = function_ptrs + function_number*8
   jsr call_worker               ; call the worker 

   ; carry clear? - nothing to do, call worker again next frame
   bcc call_worker_next_frame    

   ; carry is set - this means remove current worker and add the new workers
   LoadW R15, workers_to_add
   ldx #4                        ; max of 4 pseudo pointers to add
   ldy #3
append_workers:   
   iny                           ; advance to next worker to load
   lda (R0),y                    ; get the 1 byte pseudo pointer
   beq no_more_workers_2_append  ; null ptr found - stop evaluation workers to add
   jsr array_append              ; add it to the list of pointers to add 
   dex                           ; dec the counter of allowed pointers to add
   bne append_workers            ; try one more
no_more_workers_2_append:
   LoadW R15, workers_to_remove
remove_this_fnum:   
   lda #$F2                      ; this is function num we want to remove - was stored upstream here
   jsr array_append              ; add the current
call_worker_next_frame:   
   plx                           ; restore worker index   
   inx                           ; advance to next index
   pla                           ; restore count
   dec
   bne fetch_next_worker         ; not at zero? get next worker

   jsr update_work_queue         ; update the workers list by removing old and adding new workers

work_loop_empty:
   
   rts
.endproc

; call the worker 
; pass this pointer in R15
;
; R0: ptr into function_ptrs table (function_ptrs + (worker index * 8))
;
; a,x,y get thrashed, R0 is pushed, popped
;
; return: 
;  C = 0: worker not done, call again next frame
;  C = 1: worker has completed its work
;
.proc call_worker
   ldy #0
   ; load address to jump to and write it to jsr below
   lda (R0),y
   sta jsr_to_patch+1
   iny 
   lda (R0),y
   sta jsr_to_patch+2
   ; load this pointer and copy it to R15
   iny
   lda (R0),y
   sta R15L
   iny
   lda (R0),y
   sta R15H      
   PushW R0                      ; save R0
jsr_to_patch:   
   jsr $CA11                     ; dispatch the call
   PopW R0

   rts
.endproc

; take remove / add workers to queue
.proc update_work_queue
   LoadW R15, work_queue
   
   LoadW R14, workers_to_remove
   jsr array_remove_array        ; remove the ones to remove
   lda #0
   sta (R14)                     ; empty remove array

   LoadW R14, workers_to_add
   jsr array_append_array        ; append the ones to append
   lda #0
   sta (R14)                     ; empty append array

   rts
.endproc


.endif