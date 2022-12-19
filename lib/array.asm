.ifndef array_append

.include "regs.inc"
.include "mac.inc"

; R15 - pointer to the array
; a - the value to add
.proc array_append
   tax
   lda (R15)
   inc 
   sta (R15)
   tay
   txa 
   sta (R15),y
   rts
.endproc

; R15 - pointer to the array
; a - the value to remove (only the first found occurrence gets removed)
.proc array_remove
   pha
   lda (R15)
   tax
   pla
   ldy #1
loop:   
   cmp (R15),y
   beq remove_it
   iny
   dex
   cpx #1
   bne loop
   rts
remove_it:
   cpx #2
   beq decrease_size
   lda R15L
   sec
   sbc #1
   sta R14L
   lda R15H
   sbc #0
   sta R14H
remove_loop:   
   iny
   dex
   lda (R15),y
   sta (R14),y
   cpx #1
   bne remove_loop
decrease_size:
   lda (R15)
   dec
   sta (R15)
   rts
.endproc

.endif