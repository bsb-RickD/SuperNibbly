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

;
; work queue structure
;                                ; offset explanation
; .word ptr exec                 ; 0      pointer to the execute queue (list)
; .word ptr add                  ; 2      pointer to the add queue (list)
; .word ptr remove               ; 4      pointer to the add queue (list)
;


; initialize the work queue (empty the queue)
;
; R15 points to the work queue structure
;
.proc init_work_queue
   ThisLoadW R15,R14,0        ; load execute queue into R14
   lda #0
   sta (R14)
   ThisLoadW R15,R14          ; load add queue into R14
   lda #0
   sta (R14)
   ThisLoadW R15,R14          ; load del queue into R14
   lda #0
   sta (R14)
   rts
.endproc


; 
; add an element to the work queue without knowing it's internals
;
; R15 points to the work queue structure
;
; a - element to add
;
.proc add_to_work_queue   
   PushW R15,x
   pha
   ThisLoadW R15,R15,0,-
   pla
   jsr array_append
   PopW R15
   rts
.endproc

;
; execte the work queue - call this once a frame (or as often as you want to step)
;
; R15 points to the work queue structure
; 
; registers R0, R1, R12, R13, R14, R15 are being used / modified
;
.proc execute_work_queue
   ThisLoadW R15, R13, 0,-       ; get work queue pointer into R13
   lda (R13)                     ; worker count
   beq work_loop_empty
   MoveW R15, R12,x              ; remember the this pointer to the work queue object in R12
   ldy #1
fetch_next_worker:
   pha                           ; push the number of workers to call
   phy                           ; save worker index

   lda (R13),y                   ; get next function number
   sta R1L                       ; remember it, in case we need to remove it on completion
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
   ThisLoadW R12,R15,2,-         ; R15 points to workers_to_add, y is 3 afterwards (just as we need it)
   ldx #4                        ; max of 4 pseudo pointers to add
append_workers:   
   iny                           ; advance to next worker to load
   lda (R0),y                    ; get the 1 byte pseudo pointer
   beq no_more_workers_2_append  ; null ptr found - stop evaluation workers to add
   jsr array_append              ; add it to the list of pointers to add 
   dex                           ; dec the counter of allowed pointers to add
   bne append_workers            ; try one more
no_more_workers_2_append:
   ThisLoadW R12,R15,4,-         ; R15 points to workers_to_remove
   lda R1L                       ; this is function num we want to remove - was remembered upstream
   jsr array_append              ; add the current
call_worker_next_frame:   
   ply                           ; restore worker index   
   iny                           ; advance to next index
   pla                           ; restore count
   dec
   bne fetch_next_worker         ; not at zero? get next worker

   jsr update_work_queue         ; update the workers list by removing old and adding new workers

work_loop_empty:   
   rts

; (private procedure)
;
; take remove / add workers to queue
;
; called from within execute_work_queue
;
; R12 needs to point to the work queue object
;
update_work_queue:
   ThisLoadW R12,R15,0,-         ; R15 points to work queue
   ThisLoadW R12,R14,4,-         ; R14 points to workers to remove
   jsr array_remove_array        ; remove the ones to remove
   lda #0
   sta (R14)                     ; empty remove array

   ThisLoadW R12,R14,2,-         ; R14 points to workers to append
   jsr array_append_array        ; append the ones to append
   lda #0
   sta (R14)                     ; empty append array

   rts

; (private procedure)
;
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
call_worker:
   PushB R1L                           ; need to save R1L
   ThisLoadW R0, R1, 0                 ; load address to jump to R1, so we can jump there
   ThisLoadW R0, R15, -                ; load this pointer for call into R15
   PushW R0                            ; save R0
   PushW R12                           ; save R12 - the this pointer of the work queue
   jsr jsr_indirect                    ; dispatch the call
   PopW R12                               
   PopW R0                             ; restore R0 - this is needed for getting the commands to add
   PopB R1L                            ; restore it
   rts
jsr_indirect:
   jmp (R1)
.endproc



.endif