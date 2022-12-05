.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.include "ut.asm"
.include "math.asm"

.proc main   
   printl str_ut_welcome
   
   jsr test_mul

   rts
.endproc

testcases:
.byte 1,1,1
.byte 2,2,4
.byte 17,3,17*3
.byte 15,15,15*15
.byte 3,16,3*16
num_testcases:
.byte (*-testcases)/3


.proc test_mul
   ldx num_testcases
   printl msg
   lda #1
   jsr print_hex
   rts
msg: lstr "multiply "
.endproc