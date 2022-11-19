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
.include "vera.asm"


str_mem_test_different:
.byte "memory different",0


.proc main   
   print str_ut_welcome

   jsr test_mem_different
   jsr test_mem_equal
   jsr test_krnl_decompress
   jsr test_krnl_decompress_vram

   rts
.endproc

.proc wait_key
   jsr KRNL_GETIN    ; read key
   cmp #0
   beq wait_key
   rts
.endproc

.proc test_krnl_decompress
   prints "krnl decompress"
   ; setup - init memory to ff
   fill_memory lzsa_output, LZSA_reference_len, $FF
   ; decompress
   mow #lzsa_input, R0
   mow #lzsa_output, R1
   jsr KRNL_MEM_DECOMPRESS
   ; compare and print result
   compare_memory lzsa_output, lzsa_reference, LZSA_reference_len
   ut_exp_equal
   rts
.endproc

.proc test_krnl_decompress_vram
   print msg
   prints " - #output bytes"
   ; setup - init memory to ff
   fill_memory lzsa_output, LZSA_reference_len, $FF

   ; set vera address (to 0)
   set_vera_address 0, 0, VERA_increment_1, 0
   
   ; decompress
   mow #lzsa_input, R0
   mow #lzsa_output, VERA_data0
   jsr KRNL_MEM_DECOMPRESS

   ; check number of bytes output
   lda VERA_addr_low
   cmp #LZSA_reference_len
   ut_exp_equal

   ; compare and print result
   print msg
   prints " - memcmp"
   compare_memory lzsa_output, lzsa_reference, LZSA_reference_len
   ut_exp_equal
   rts
msg:
.byte "krnl decompress vram",0
.endproc


.proc test_mem_equal
   print msg
   prints "1"
   compare_memory memory_1, memory_1, MEMORY_len
   ut_exp_equal

   print msg
   prints "2"
   fill_memory memory_1, MEMORY_len, $AB
   fill_memory lzsa_output, MEMORY_len, $AB
   compare_memory memory_1, lzsa_output, MEMORY_len
   ut_exp_equal
   rts
msg:
.byte "mem same ",0
.endproc

.proc test_mem_different
   prints "mem different"
   compare_memory memory_1, memory_2, lzsa_output
   ut_exp_neq  ; we expect compary to report difference!
   rts
msg:

.endproc



memory_1: .byte 1,2,3,4,5,6,7,8,9,10
MEMORY_len = *-memory_1
memory_2: .byte 1,2,3,4,7,6,7,8,9,10

lzsa_reference:
.incbin "test.bin"

LZSA_reference_len = *-lzsa_reference

lzsa_input:
.incbin "test.cpr"

LZSA_input_len = *-lzsa_input

lzsa_output:
