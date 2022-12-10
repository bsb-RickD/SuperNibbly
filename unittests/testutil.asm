.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.include "common.inc"
.include "ut.asm"
.include "util.asm"

.proc main   
   printl str_ut_welcome
      
   jsr test_stub

   rts
.endproc

; bla
.proc test_stub
   prints "some test"

   /*
   ; init the VRAM, and ram buffer
   jsr test_helper_init_vram
   
   ; copy back
   set_vera_address 0               ; we'll read back from d0
   copy_memory VERA_data0, test_vram_buffer, TEST_vram_reference_len

   ; compare
   compare_memory test_vram_buffer, test_vram_reference, TEST_vram_reference_len
   */

   ut_exp_equal

   rts
.endproc 