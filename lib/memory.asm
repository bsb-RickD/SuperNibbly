.ifndef MEMORY_ASM
MEMORY_ASM = 1

.segment "CODE"

.ifndef MEMORY_INC
.include "lib/memory.inc"
.endif

.export copy_memory_bank_safe
 
;
; R0: source
; R1: target
; R2: num bytes
;
; you can use this to copy from main RAM to banked RAM, across bank borders.
; trying to copy from banked ram to banked ram will not work (undefined behavior)
;
.proc copy_memory_bank_safe
   AddW3 R1,R2,R3          ; add target + num bytes 
   bcs copy_multiple_pages ; if carry is set, we even had an overflow beyond R3H
   cmp #$C0                ; a still holds the R3H value from the comparison - check wether we left the 8K bank window
   blt do_last_copy
copy_multiple_pages:
   MoveW R2,R3             ; R3 = copy of num bytes
page_loop:   
   LoadW R2, $C000
   SubW R1,R2              ; R2 = length to bank boundary

   PushW R2
   jsr KRNL_MEM_COPY       ; do the actual partial copy
   PopW R2

   LoadW R1, $A000         ; set new destination at begining.. 
   inc BANK                ; ..of next bank

   AddW R2,R0              ; advance R0 by the number of bytes copied
   SubW R2,R3              ; subtract the copied amount to get the remaining length

   cmp #32                 ; a is still R3H, compare if we have more than a full page
   bge page_loop           ; copy another page

   MoveW R3,R2             ; last piece, copy length from R3 to R2
do_last_copy:
   jmp KRNL_MEM_COPY       ; copy last piece, and let the kernal return to our caller
.endproc

.endif