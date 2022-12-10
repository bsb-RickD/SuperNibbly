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
      
   jsr test_push_pop

   rts
.endproc

push_pop_expected:
.byte 0,1,2,3,0,0,6,7,0,0,$A,$B,0,0,$E,$F,0,0,0,0,$14,$15,$16,$17,0,0,0,0,$1C,$1D,$1E,$1F

.proc test_push_pop
   prints "push_registers"

   ldx #32
   ldy #0

   ; distinct pattern
fill:
   tya
   sta R0,y
   iny
   dex
   bne fill

   ; push some
   lda #%10101011
   jsr push_registers_0_to_7
   lda #%11001100
   jsr push_registers_8_to_15

   ; clear all
   ldx #32
   ldy #0
   lda #0
clear:
   sta R0,y
   iny
   dex
   bne clear

   ; pop the pushed ones
   lda #%11001100
   jsr pop_registers_8_to_15   
   lda #%10101011
   jsr pop_registers_0_to_7

   ldy #0
compare:   
   lda R0,y
   cmp push_pop_expected,y
   bne different
   iny
   cpy #32
   bne compare
different:   
   ut_exp_equal
   rts
.endproc 