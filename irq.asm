.include "zeropage_constants.asm"
.include "kernal_constants.asm"
.include "helpers.asm"

; globals
default_irq:   .addr 0

; R0 points to custom IRQ handler, previous IRQ vector is saved in default_irq
.proc init_irq   
   sei                     ; disable interrupts while we fiddle around
   mow IRQVec,default_irq  ; first, rember the original interrupt handler
   mow R0,IRQVec           ; second, hook in our IRQ handler
   cli                     ; enable interrupts again
   rts
.endproc   

.proc reset_irq
   sei                     ; disable interrupts while we fiddle around
   mow default_irq, IRQVec ; restore original interrupt vector
   cli                     ; enable interrupts again
   rts
.endproc