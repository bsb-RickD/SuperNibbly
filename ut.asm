str_ut_welcome:
.byte "=== unit test framework ===", CHR_NL, CHR_NL, 0

str_ut_result_separator:
.byte ": ",0

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

.macro compare_memory mem1, mem2, len
   mow #mem1, R11
   mow #mem2, R12
   lxy #len
   jsr compare_memory_
.endmacro

; it is a pass if carry is clear
.macro ut_exp_pass
   jsr ut_pass_on_cc
.endmacro

; it is a pass if carry is set
.macro ut_exp_fail
   jsr ut_pass_on_cs
.endmacro


; print unit test result - passed if carry is clear
.proc ut_pass_on_cc
   php
   print str_ut_result_separator
   plp
   bcs failed
   print str_ut_passed
   rts
failed:
   print str_ut_failed
   rts
.endproc

; print unit test result - passed if carry is set
.proc ut_pass_on_cs
   ; negate carry
   rol            ; Cb into b0
   eor   #$01     ; toggle bit
   ror            ; b0 into Cb
   bra   ut_pass_on_cc
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
; carry clear: memory equal
; carry set: memory different (R11, R12 point to differing memory)
.proc compare_memory_
   lda (R11)
   cmp (R12)
   bne different
   IncW R11
   IncW R12
   dex
   bne compare_memory_
   dey
   bmi same
   ldx #$FF
   bra compare_memory_
different:
   sec
   rts
same:
   clc
   rts
.endproc