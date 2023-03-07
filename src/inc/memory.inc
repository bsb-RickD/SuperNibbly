.ifndef MEMORY_INC
MEMORY_INC = 1

.ifndef REGS_INC
.include "inc/regs.inc"
.endif

.ifndef KERNAL_INC
.include "inc/kernal.inc"
.endif

.macro fill_memory start, count, value
   LoadW R0, start
   LoadW R1, count
   lda #value
   jsr KRNL_MEM_FILL
.endmacro

.macro copy_memory source, dest, count
   LoadW R0, source
   LoadW R1, dest
   LoadW R2, count
   jsr KRNL_MEM_COPY
.endmacro

.macro copy_2_banked_memory source, dest, count
   LoadW R0, source
   LoadW R1, dest
   LoadW R2, count
   jsr copy_memory_bank_safe   
.endmacro

.endif