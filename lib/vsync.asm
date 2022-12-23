.ifndef VSYNC_ASM
VSYNC_ASM = 1

.ifndef IRQ_ASM
.include "irq.asm"
.endif

; globals
vsync_count:      .word 0

VSYNC_worker_ptr = ZEROPAGE_SCRATCH

; use this macro to install code to be executed in the vsync
; at the end of the routine do a "jmp vsync_irq_exit"
.macro set_vsync_worker ptr
   LoadW VSYNC_worker_ptr, ptr
.endmacro


; use this macro to remove vsync callbacks again
;
.macro clear_vsync_worker
   set_vsync_worker vsync_irq_exit
.endmacro


; install vsyc interrupt and and optional worker
;
.macro init_vsync_irq worker
   .if .paramcount = 1
      set_vsync_worker worker
   .else
      ; clear the worker
      clear_vsync_worker
   .endif
   ; save irq, and install our vsync_irq
   LoadW R0, vsync_irq
   jsr init_irq
.endmacro

; wait for next vsync (or return immediately if one or multiple vsyncs have occured in the meantime)
; vsync count is zero afterwards
; 
.proc wait_for_vsync
   lda vsync_count
   beq wait_irq          ; vsync_count still zero? must have been some other IRQ
   stz vsync_count
   rts
 wait_irq:
   wai
   bra wait_for_vsync
.endproc


; remove vsync interrupr again
;
.macro clear_vsync_irq
   jsr reset_irq
.endmacro


; the actual vsync routine
;
; increases the vsync count
;
.proc vsync_irq
   php                                 ; save flags
   sei                                 ; disable interrupts
   lda VERA_isr
   and #1                              ; check vsync bit
   beq vsync_irq_exit                  ; bit 1 not set - no vsync

   ; we have a vsync - increase the vsync_count
   inc vsync_count
   bne custom_code
   inc vsync_count+1                   ; overflow into second byte
   ; here we jump to the custom code
custom_code:   
   jmp (VSYNC_worker_ptr)
.endproc   

; jump here at the end of your custom irq code
;
vsync_irq_exit:
   plp                                 ; don't re-enable interrupts, the flag knows the prev state anyhow
   jmp (default_irq)

.endif