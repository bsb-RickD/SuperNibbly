.ifndef IRQ_ASM
IRQ_ASM = 1

.segment "CODE"

.ifndef KERNAL_INC
.include "inc/kernal.inc"
.endif

.ifndef MAC_INC
.include "inc/mac.inc"
.endif

.ifndef REGS_INC
.include "inc/regs.inc"
.endif

.ifndef VERRA_INC
.include "inc/vera.inc"
.endif


; globals
default_irq:      .addr 0   
previous_ien:     .byte 0

; R0 points to custom IRQ handler, previous IRQ vector is saved in default_irq
.proc init_irq   
   sei                           ; disable interrupts while we fiddle around
   MoveW IRQVec,default_irq      ; first, rember the original interrupt handler ..
   MoveB VERA_ien, previous_ien  ; .. and the enable bits
   MoveW R0,IRQVec               ; second, hook in our IRQ handler
   cli                           ; enable interrupts again
   rts
.endproc   

.proc reset_irq
   sei                           ; disable interrupts while we fiddle around
   MoveW default_irq, IRQVec     ; restore original interrupt vector ..
   MoveB previous_ien, VERA_ien  ; .. and the enable bits
   cli                           ; enable interrupts again
   rts
.endproc

.endif