.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.include "kernal_constants.asm"
.include "regs.inc"
.include "helpers.asm"
.include "ut.asm"

str_mem_test_equal:
.byte "memory same",0

str_mem_test_different:
.byte "memory different",0

.proc main   
   print str_ut_welcome

   print str_mem_test_equal
   mow #memory_1, R11
   mow #memory_1, R12
   ldx #10
   ldy #0
   jsr compare_memory
   jsr ut_pass_on_cc   

   print str_mem_test_different
   mow #memory_1, R11
   mow #memory_2, R12
   ldx #10
   ldy #0
   jsr compare_memory
   jsr ut_pass_on_cs          ; we expect compary to report difference!

   fill_memory lzsa_output, LZSA_reference_len, $FF

   jsr wait_key
   rts
.endproc

.proc wait_key
   jsr KRNL_GETIN    ; read key
   cmp #0
   beq wait_key
   rts
.endproc

memory_1: .byte 1,2,3,4,5,6,7,8,9,10
memory_2: .byte 1,2,3,4,7,6,7,8,9,10

lzsa_reference:
.incbin "test.bin"

LZSA_reference_len = *-lzsa_reference

lzsa_input:
.incbin "test.cpr"

LZSA_input_len = *-lzsa_input

lzsa_output:
