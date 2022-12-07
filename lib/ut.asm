.ifndef ut_pass_on_equal

.include "common.inc"
.include "print.asm"

str_ut_welcome:
.byte (str_ut_passed-1-*),"=== unit test framework ===", CHR_NL, CHR_NL

str_ut_passed:
.byte (str_ut_failed-1-*), CHR_COLOR_GREEN, "passed", CHR_COLOR_WHITE, CHR_NL

str_ut_failed:
.byte (str_ut_failed_end-1-*), CHR_COLOR_RED, "failed", CHR_COLOR_WHITE, CHR_NL
str_ut_failed_end:

.macro compare_memory mem1, mem2, len
   LoadW R11, mem1
   LoadW R12, mem2
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
   printl str_ut_passed
   rts
failed:
   printl str_ut_failed
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

.endif