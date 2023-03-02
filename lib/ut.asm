.ifndef UT_ASM
UT_ASM = 1

.segment "CODE"

.ifndef COMMON_INC
.include "inc/common.inc"
.endif

.ifndef PRINT_INC
.include "lib/print.inc"
.endif

.import print_length_leading

.export ut_pass_on_equal, ut_pass_on_not_equal, compare_memory, str_ut_welcome

str_ut_welcome: Lstr "=== unit test framework ===", CHR_NL, CHR_NL
str_ut_passed: Lstr CHR_COLOR_GREEN, "passed", CHR_COLOR_WHITE, CHR_NL
str_ut_failed: Lstr CHR_COLOR_RED, "failed", CHR_COLOR_WHITE, CHR_NL

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
.proc compare_memory
   lda (R11)
   cmp (R12)
   bne done
   IncW R11
   IncW R12
   dex
   bne compare_memory
   dey
   bmi same
   ldx #$FF
   bra compare_memory
same:
   lda #0   
done:
   rts
.endproc


.endif