.ifndef UT_INC
UT_INC = 1

.ifndef COMMON_INC
.include "inc/common.inc"
.endif

.macro cmp_memory mem1, mem2, len
   LoadW R11, mem1
   LoadW R12, mem2
   lxy #len
   jsr compare_memory
.endmacro

; it is a pass Z is set
.macro ut_exp_equal
   jsr ut_pass_on_equal
.endmacro

; it is a pass if Z is clear
.macro ut_exp_neq
   jsr ut_pass_on_not_equal
.endmacro

; use this to fail unconditionally
.macro ut_fail
   lda #0
   ut_exp_neq
.endmacro

; use this to pass unconditionally
.macro ut_pass
   lda #0
   ut_exp_equal
.endmacro

.macro ut_exp_memory_equal mem1, mem2, len
   cmp_memory mem1, mem2, len
   ut_exp_equal
.endmacro

.macro ut_exp_memory_neq mem1, mem2, len
   cmp_memory mem1, mem2, len
   ut_exp_neq
.endmacro

.endif