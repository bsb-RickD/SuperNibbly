str_ut_welcome:
.byte "=== unit test framework ===", CHR_NL, CHR_NL, 0

str_ut_passed:
.byte CHR_COLOR_GREEN, "passed", CHR_COLOR_WHITE, CHR_NL, 0
str_ut_failed:
.byte CHR_COLOR_RED, "failed", CHR_COLOR_WHITE, CHR_NL, 0

.macro prints str
   .local @msg
   .local @end
   mow #@msg, R11
   ldx #(@end-@msg)
   jsr print_x_length
   bra @end
@msg:
.byte str
@end:
.endmacro

; switch vera back to data port 0 - CHROUT depends on that
.macro switch_vera_to_dataport_0
   stz VERA_ctrl
.endmacro

.macro print str
   mow #str, R11
   jsr print_zero_terminated
.endmacro

.macro fill_memory start, count, value
   mow #start, R0
   mow #count, R1
   lda #value
   jsr KRNL_MEM_FILL
.endmacro

.macro copy_memory source, dest, count
   mow #source, R0
   mow #dest, R1
   mow #count, R2
   jsr KRNL_MEM_COPY
.endmacro


.macro compare_memory mem1, mem2, len
   mow #mem1, R11
   mow #mem2, R12
   lxy #len
   jsr compare_memory_
.endmacro

; it is a pass Z is set
.macro ut_exp_equal
   jsr ut_pass_on_equal
.endmacro

; it is a pass if Z is clear
.macro ut_exp_neq
   jsr ut_pass_on_not_equal
.endmacro


; print unit test result - passed if Z is set
.proc ut_pass_on_equal
   php
   sec
   jsr KRNL_PLOT
   clc
   ldy #40
   jsr KRNL_PLOT
   plp
   bne failed
   print str_ut_passed
   rts
failed:
   print str_ut_failed
   rts
.endproc

; print unit test result - passed if Z is clear
.proc ut_pass_on_not_equal
   ; negate Z
   beq zero_set
   lda #0
   bra ut_pass_on_equal
zero_set:
   lda #1
   bra ut_pass_on_equal
.endproc


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

; R11 points to mem1
; R12 points to mem2
; x,y bytes to compare (low, high)
;
; Z set: memory equal
; Z clear: memory different (R11, R12 point to differing memory)
.proc compare_memory_
   lda (R11)
   cmp (R12)
   bne done
   IncW R11
   IncW R12
   dex
   bne compare_memory_
   dey
   bmi same
   ldx #$FF
   bra compare_memory_
same:
   lda #0   
done:
   rts
.endproc