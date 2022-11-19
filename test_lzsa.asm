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

str_krnl_decompress:
.byte "krnl decompress",0


.proc main   
   print str_ut_welcome

   print str_mem_test_equal
   compare_memory memory_1, memory_1, 10
   ut_exp_pass

   print str_mem_test_different
   compare_memory memory_1, memory_2, 10
   ut_exp_fail  ; we expect compary to report difference!

   ; == test kernal decompress ============================
   print str_krnl_decompress   
   ; init memory to ff
   fill_memory lzsa_output, LZSA_reference_len, $FF
   ; decompress
   mow #lzsa_input, R0
   mow #lzsa_output, R1
   jsr KRNL_MEM_DECOMPRESS
   ; compare output with reference
   compare_memory lzsa_output, lzsa_reference, LZSA_reference_len
   ; print result
   ut_exp_pass
   ; ======================================================


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
