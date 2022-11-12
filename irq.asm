.include "zeropage_constants.asm"
.include "kernal_constants.asm"
.include "helpers.asm"

; globals
default_irq:   .addr 0

; R0 points to custom IRQ handler, previous IRQ vector is saved in default_irq
.proc init_irq   
   sei                  ; disable interrupts while we fiddle around
   
   /*
   lda IRQVec           ; first, rember the original interrupt handler
   sta default_irq
   lda IRQVec+1
   sta default_irq+1
   */
   mow IRQVec,default_irq  ; first, rember the original interrupt handler

   /*
   lda R0               ; second, hook in our IRQ handler
   sta IRQVec
   lda R0+1
   sta IRQVec+1
   */
   mow R0,IRQVec           ; second, hook in our IRQ handler
   
   cli                     ; enable interrupts again
   rts
.endproc   

.proc reset_irq
   sei                                 ; disable interrupts while we fiddle around

   lda default_irq                     ; restore original interrupt vector
   sta IRQVec
   lda default_irq+1
   sta IRQVec+1
   
   cli                                 ; enable interrupts again
   rts
.endproc