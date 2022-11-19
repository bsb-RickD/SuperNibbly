str_ut_welcome:
.byte "=== unit test framework ===", CHR_NL, 0

str_ut_result_separator:
.byte ": ",0

str_ut_passed:
.byte CHR_COLOR_GREEN, "passed", CHR_COLOR_WHITE, CHR_NL, 0
str_ut_failed:
.byte CHR_COLOR_RED, "failed", CHR_COLOR_WHITE, CHR_NL, 0

.macro print str
   mow #str, R11
   jsr print_
.endmacro

.macro fill_memory start, count, value
   mow #start, R0
   mow #count, R1
   lda #value
   jsr KRNL_MEM_FILL
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
.proc print_
   ldy #0
print_next_char:  
   lda (R11),y
   beq done
   jsr KRNL_CHROUT
   iny
   bne print_next_char
   inc R11H
   bra print_
done:
   rts
.endproc

; R11 points to mem1
; R12 points to mem2
; x,y bytes to compare (low, high)
;
; carry clear: memory equal
; carry set: memory different (R11, R12 point to differing memory)
.proc compare_memory
   lda R11
   cmp R12
   bne different
   IncW R11
   IncW R12
   dex
   bne compare_memory
   dey
   bmi same
   ldx #$FF
   bra compare_memory
different:
   sec
   rts
same:
   clc
   rts
.endproc