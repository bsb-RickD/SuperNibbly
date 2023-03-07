.ifndef VSYNC_INC
VSYNC_INC = 1

.ifndef REGS_INC
.include "inc/regs.inc"
.endif

.ifndef MAC_INC
.include "inc/mac.inc"
.endif

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

; remove vsync interrupt again
;
.macro clear_vsync_irq
   jsr reset_irq
.endmacro


.endif