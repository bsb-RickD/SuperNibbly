.ifndef print_zero_terminated

.include "../inc/common.inc"

; print a string that was passed as parameter: prints "erik was here"
.macro prints str
   .local @msg
   .local @end
   LoadW R11, @msg
   ldx #(@end-@msg)
   jsr print_x_length
   bra @end
@msg:
.byte str
@end:
.endmacro

; print a string at addr that has a leading length
.macro printl addr
   LoadW R11, addr
   jsr print_length_leading
.endmacro

; print a string at addr that is zero terminated
.macro printz addr
   LoadW R11, addr
   jsr print_zero_terminated
.endmacro


; R11 points to string, zero terminated
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

; R11 points to string, which has the length as first byte
.proc print_length_leading
   ldy #1
   lda (R11)
   tax
   bra print_x_length+2
.endproc   

; R11 points to string, x holds length
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

.proc print_hex_digit
   and #$0f
   adc #$30    ; $30 = "0"
   cmp #$3A    ; did we exceed 0..9?
   bcc print_char
   adc #$26    ; bring it to the "A".."F" range
print_char:
   jsr KRNL_CHROUT
   rts
.endproc

.proc print_hex
   pha
   ror
   ror
   ror
   ror
   clc
   jsr print_hex_digit
   pla
   bra print_hex_digit
.endproc

.endif