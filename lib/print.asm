.ifndef PRINT_ASM
PRINT_ASM = 1

.segment "CODE"

.ifndef COMMON_INC
.include "inc/common.inc"
.endif

.export print_x_length, print_length_leading, print_zero_terminated

; R11 points to string, zero terminated
.ifref print_zero_terminated 
.proc print_zero_terminated
   ldy #0
print_next_char:  
   lda (R11),y
   beq done
   jsr KRNL_CHROUT
   iny
   bne print_next_char
   inc R11H
   bra print_zero_terminated
done:
   rts
.endproc
.endif

; R11 points to string, which has the length as first byte
.ifref print_length_leading 
.refto print_x_length
.proc print_length_leading 
   ldy #1
   lda (R11)
   tax
   bra print_x_length+2
.endproc   
.endif

; R11 points to string, x holds length
.ifref print_x_length
.proc print_x_length
   ldy #0
print_next_char:   
   lda (R11),y
   jsr KRNL_CHROUT
   iny
   dex
   bne print_next_char
   rts
.endproc
.endif

.endif